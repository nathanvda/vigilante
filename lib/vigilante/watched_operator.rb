module Vigilante
  module WatchedOperator

    def self.included(base)
      base.has_many :authorizations, :foreign_key => 'operator_id', :dependent => :destroy
      base.has_many :abilities, :through => :authorizations

      base.accepts_nested_attributes_for :authorizations, :reject_if => proc {|x| x[:ability_id].blank?}, :allow_destroy => true
      base.attr_accessible :authorizations_attributes if base.respond_to?(:attr_accessible)
    end

    def add_authorization(role, extent=nil)
      ability = Ability.where("lower(name) = '#{role.downcase}'")
      raise StandardError.new("Role #{role} is not converted to a corresponding authorization. It does not exist.") if ability.nil?

  #    extent_params = {}
  #    unless extent.nil?
  #      extent_params[:extent] = extent.id
  #      extent_params[:extent_type] = extent.class.name
  #    end

      new_authorization = ::Authorization.create(:operator_id => self.id, :ability_id => ability.id)
      unless extent.nil?
        new_authorization.add_extent(extent)
      end
      authorizations << new_authorization
      new_authorization
    end

    def find_authorization(role, extent=nil)
      authorizations.each do |auth|
        return auth if auth.ability.name.downcase == role.downcase && (auth.match_extent(extent) || extent == :any)
      end
      nil
    end

    def find_or_create_authorization(role, extent = nil)
      auth = find_authorization(role, :any)
      if auth.nil?
        auth = add_authorization(role, extent)
      elsif extent.present?
        auth.add_extent(extent)
      end
      auth
    end



    ###### TODO: should we keep the 'role' name?
    ###### Isn't that confusing? Abilities-|Authorizations-Roles?

    #  an array containing any of existing ability-names
    #  will add the corresponding ability
    def roles=(roles_arr)
      self.authorizations = []
      roles_arr.each do |role|
        find_or_create_authorization(role) unless role.blank?
      end
    end

    # convenience method: needed?
    def add_role(role)
      find_or_create_authorization(role)
    end

    # convenience method: list all assigned roles (without extent?)
    def roles
      # we can't use abilities as those are not defined when creating a new operator that is not yet saved
      #result = abilities.collect(&:name)
      authorizations.collect{|auth| auth.ability.try(:name)}
    end

    def show_roles
      authorizations.collect {|a| a.ability.try(:name) + "[" + a.authorization_extents.collect{|e| e.extent}.join(',') + "]"}
    end

    def max_ability(extent=nil)
      if extent && has_extent?
        result_max = 0
        self.reload.authorizations.each do |auth|
          if auth.has_extent?
            result_max = auth.ability.importance if auth.match_extent(extent) && auth.ability.importance > result_max
          end
        end
        result_max
      else
        @max_importance ||= abilities.maximum(:importance)
      end
    end


    #### Extent-specific

    def add_to_extent(extent, role = nil)
      #### TODO: configure default role!!!
      role = 'can-read-all' if role.nil?
      find_or_create_authorization(role, extent)
    end

    def extent_role(extent)
      return nil if extent.nil?
      self.reload.authorizations.each do |auth|
        if auth.has_extent?
          return auth.ability.name if auth.match_extent(extent)
        end
      end
      nil
    end

    def has_extent?
      extent_roles.count >= 1
    end

    def extent_roles
      self.authorizations.select{|x| x.has_extent? }.collect{|x| x.ability.name }
    end

    def extents_with_roles
      extent_hash = Hash.new { |h, k| h[k] = [] }
      self.authorizations.each do |authorization|
        if authorization.has_extent?
          authorization.authorization_extents.each do |x|
            extent_hash[x.extent_objid] << authorization.ability.name
          end
        else
          extent_hash[:all] << authorization.ability.name
        end
      end
      extent_hash
    end


    def validate_authorizations(max_allowed_importance, only_with_extents)
      authorizations = self.authorizations

      authorizations.each do |auth|
        ability = auth.ability

        if ability.needs_extent? && auth.authorization_extents.empty?
          errors.add(:authorizations, "ability #{ability.name} requires an organisation!")
        end
        if ability.importance > max_allowed_importance || (!ability.needs_extent? && only_with_extents)
          errors.add(:authorizations, "you do not have the necessary permission to add ability #{ability.name}")
        end
      end

      logger.debug "###### Validate_operator_authorizations: authorizations = #{authorizations.inspect}"
      logger.debug "###### Validate_operator_authorizations: authorizations = #{abilities.inspect}"

      if authorizations.empty?
        valid? # add the other errors, if any
        errors.add(:authorizations, 'must have at least one ability')
      end
    end


    def simplify_authorizations
      if authorizations.count != distinct_authorizations.count
        minimize_authorizations
        self.reload
      end
    end

    def distinct_authorizations
      authorizations.joins(:ability).select('distinct(name)')
    end

    def authorizations_by_ability_name(ability_name)
      #TODO: this can be written with better perfomance by using an SQL select instead of the ruby method select
      authorizations.select{|authorization|authorization.ability.name == ability_name}
    end

    def minimize_authorizations
      distinct_authorizations.each do |ability|
        authorizations_with_possible_duplicates = authorizations_by_ability_name(ability.name)
        if authorizations_with_possible_duplicates.size > 1
          keep_auth = authorizations_with_possible_duplicates.delete_at(0)
          authorizations_with_possible_duplicates.each do |dup_auth|
            dup_auth.authorization_extents.each do |auth_ext|
              keep_auth.authorization_extents.create(:extent_objid => auth_ext.extent_objid, :extent_type => auth_ext.extent_type)
            end
            dup_auth.destroy
          end
        end
      end
    end



    #### Permits: what is an user/operator/... allowed to do

    ## keep permits
    def permits=(permissions)
      # make a copy!
      @permissions = {}.merge(permissions)
    end

    def permits
      @permissions ||= build_permissions_hash
    end

    protected

    def build_permissions_hash
      authorizations = self.authorizations
      list_of_auth = []
      authorizations.each do |auth|
        auth_extents = auth.authorization_extents.all.collect(&:extent_objid)
        auth.ability.permissions.each do |perm|
          match = /^(.*?)(?:\[(.*)\])*$/.match(perm.allowed_action)
          basic_hash = {
              :path => match[1],
              :actions => (match[2]||"").split(',').collect { |x| x.strip.to_sym }
          }
          if auth_extents.size == 0
            list_of_auth << basic_hash.merge(:extent => '*')
          else
            auth_extents.each {|ext| list_of_auth << basic_hash.merge(:extent => ext) }
          end
        end
      end

      permits = PermissionHash.new

      list_of_auth.each do |auth|
        permits.add(auth[:extent].to_s, auth[:path], auth[:actions])
      end

      logger.debug "Built permissions-hash = #{permits.inspect}"

      permits
    end

  end
end