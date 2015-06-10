module Vigilante
  module WatchedOperator

    def self.included(base)
      base.has_many :authorizations, :foreign_key => 'operator_id', :dependent => :destroy
      base.has_many :abilities, :through => :authorizations

      base.accepts_nested_attributes_for :authorizations, :reject_if => proc {|x| x[:ability_id].blank?}, :allow_destroy => true
      base.attr_accessible :authorizations_attributes if base.respond_to?(:attr_accessible)
    end

    def add_authorization(role, extent=nil)
      ability = Ability.find_by_name(role.downcase)
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
      asp_roles.count >= 1
    end

    def extent_roles
      self.authorizations.select{|x| x.has_extent? }.collect{|x| x.ability.name }
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