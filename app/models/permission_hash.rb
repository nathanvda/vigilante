class PermissionHash < HashWithIndifferentAccess

  DEFAULT_PERMISSIONS = HashWithIndifferentAccess.new({'*' => {
        :homepage => {:index => 1, :show => 1}
      }
    })

  def self.default
    PermissionHash.new(DEFAULT_PERMISSIONS)
  end

  # default initialization
  def initialize(default_start = DEFAULT_PERMISSIONS)
    new_start = HashWithIndifferentAccess.new
    #deep clone the default_start to not change it
    default_start.each do |key, val|
      new_start[key] = val.clone
    end
    super( new_start )
  end

  # add extra allowed actions
  def add(extent, path, allowed_actions)
    self[extent]       ||= {}
    self[extent][path] ||= {}

    allowed_actions = [:index, :show] if allowed_actions.nil? || allowed_actions.empty?
    allowed_actions.push(:update) if allowed_actions.include?(:edit) && !allowed_actions.include?(:update)
    allowed_actions.push(:create) if allowed_actions.include?(:new) && !allowed_actions.include?(:create)

    allowed_actions.each do |a|
      self[extent][path][a] = 1
    end
    self
  end

  # get_extent_of calculates the extent of a
  #     given controller/action for this permissionhash
  # this returns either
  #  - []  : no extent, nothing is allowed
  #  - [extent_objid, ..] : the extent
  #  Note: if the extent of the permission is global the returned array will include '*'
  def get_extent_of(controller_name, action)
    controller_name = to_controller_name(controller_name) unless controller_name.instance_of?(String)

    permission_extent = []
    self.keys.each do |extent|
      if is_allowed_by_permissions(controller_name, action, self[extent])
        permission_extent << extent.to_s
      end
    end
    permission_extent
  end


  # does this permission-hash only has global permissions (without extent)
  def are_only_global?
    self.keys.size == 1 && self.keys[0] == '*'
  end

  # convenience method
  def is_global?
    are_only_global?
  end

  def is_allowed_by_context(controller_name, action_name, extents)
    controller_name = to_controller_name(controller_name) unless controller_name.instance_of?(String)
    
    is_allowed_by_permissions(controller_name, action_name, get_permissions_by_context(extents))
  end


  #####################################################
  #
  #          Protected methods
  #
  #####################################################

  protected


    def model_name
      controller_name.singularize.camelize
    end


    def to_controller_name(klass)
      klass_str = klass.is_a?(Class) ? klass.name :
                  klass.is_a?(String) ? klass :
                  klass.class.name
      "#{klass_str.underscore.pluralize}"
    end

    def get_permissions_by_context(extents)
      # start from the empty permissions
      result = {}
      # add specific extents
      unless extents.nil? || self.is_global?
        extents.each do |ctx_id|
          Rails.logger.debug "get_permissions_by_context add extent #{ctx_id.inspect}"          
          permissions_for_ctx = self[ctx_id]
          result.merge!(permissions_for_ctx) unless permissions_for_ctx.nil?
        end
      end

      # add general extent only if we have nothing specific
      result = {}.merge(self['*']) if result == {}
      
      result
    end

    def is_allowed_by_permissions(controller_name, action, extent_permissions)
      action = action || 'index'
      action = action.to_sym
      controller_name = 'homepage' if controller_name == '/'
      controller_name = controller_name[1..-1] if controller_name.starts_with?('/')

      p = ''
      path_parts = controller_name.split('/').collect() { |e| p = p+'/' unless p.empty?; p = p + e; p }.sort { |a, b| b.length <=> a.length }

      result     = false
      [path_parts, '*'].flatten!.each do |path|
        allowed = extent_permissions[path]
        unless allowed.nil?
          result = (allowed[action] != nil) || (allowed[:all] != nil || allowed[:'*'] != nil)
          break if result
        end
      end
      result
    end

end