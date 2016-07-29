module Vigilante
  module Authorization

    def self.included(base)
      current_user_method = VIGILANTE_CONFIG['current_user_method']

      base.helper_method :is_allowed_to?
      base.helper_method "get_#{current_user_method}_extent_of".to_sym
      base.helper_method "get_#{current_user_method}_permissions_are_global?".to_sym

      define_method "get_#{current_user_method}_extent_of" do |controller_name, action|
        get_protectee_permissions.get_extent_of(controller_name, action)
      end

      # needed? --> tells if the current_operator has only global permissions
      define_method "get_#{current_user_method}_permissions_are_global?" do
        get_protectee_permissions.are_only_global?
      end

      define_method "get_#{current_user_method}_permissions" do
        get_protectee_permissions
      end

    end

    # ******************************************************************
    # to be overruled in the project
    # returns current context where applicable

    def get_current_context_from_application
      application_method = VIGILANTE_CONFIG['application_context']
      self.send(application_method) if application_method.present?
    end

    def get_extent_id_from_context_object(context_object)
      application_method = VIGILANTE_CONFIG['application_extent_id_from_object']
      self.send(application_method, context_object) if application_method.present?
    end

    def handle_context_for_nested_resources
      application_method = VIGILANTE_CONFIG['application_context_from_nested_resources']
      self.send(application_method) if application_method.present?
    end

    # this will return the current user/operator/... that is guarded by vigilante
    def get_protectee
      current_user_method = VIGILANTE_CONFIG['current_user_method']

      Rails.logger.debug "current_user_method = #{current_user_method}"

      @protectee ||= self.send(current_user_method) if current_user_method.present?

      Rails.logger.debug "Protectee = #{@protectee.present? ? @protectee.to_s : 'NONE'}"

      @protectee
    end


    # ******************************************************************
    #  explicitely call the Vigilante filter in each controller that requires Vigilante protection :
    #     ... (fill the necessary context)
    #     before_filter :check_permissions
    #
    # If some controller is actually an API or shares permissions, you can do the following
    #
    #     before_filter :check_permissions, :as => 'posts'
    #
    # and instead of the current controller, it will use the permissions for controller posts to check if an action is allowed.
    def check_permissions(options={})
      logger.debug "CHECK PERMISSIONS"
      # a logged in operator can do ajax-requests
      return if get_protectee.present? && request.xhr?

      controller_to_check = options[:as].nil? ? controller_name : options[:as]

      signal_permission_error unless is_allowed_to?(controller_to_check, action_name, get_current_context_from_application)
    end


    # explicitely check the Vigilante permissions in a controller method :
    #
    #     def update
    #       check_permission
    #        ... do something real
    #
    #     end
    #
    # This way it is easy to protect a single action explicitly. It is even possible to use other permissions
    # E.g.
    #
    #     def update
    #       check_permission(:action => 'destroy') if params[:factory_default]
    #       ..
    #     end
    #
    # To restore to factory defaults an operator needs permission to destroy an item.
    # You could even use the permissions for another controller
    #     def update
    #       check_permission(:action => 'update', :controller => 'some_other')
    #       ..
    #     end
    #
    # This will check the permission for some_other#update to be allowed access.
    def check_permission(options={})
      controller_to_check = options[:controller] || controller_name
      action_to_check = options[:action] || action_name
      signal_permission_error unless is_allowed_to?(controller_to_check, action_to_check, get_current_context_from_application)
    end


    # ******************************************************************
    
    def is_allowed_to?(controller_name, action, context=get_current_context_from_application)
      logger.debug "is_allowed_to? #{controller_name.inspect}##{action} [#{context.inspect}]"
      get_protectee_permissions.is_allowed_by_context(controller_name, action, get_extent_from_context(context))
    end

    def get_protectee_permissions
      @permits ||= session[:permits]
      if @permits.nil?
        Rails.logger.debug "determine permissions ... "
        @permits = if get_protectee
                     get_protectee.permits
                   else
                     PermissionHash.default
                   end
        session[:permits] = @permits
      elsif @permits.class.name != "PermissionHash"
        @permits = PermissionHash.new(@permits)
      end
      @permits
    end

    def get_extent_from_context(context_objects)
      return nil if context_objects.nil?
      extent = []
      if context_objects.respond_to?(:each)
        context_objects.each do |ctx|
          extent << get_extent_id_from_context_object(ctx)
        end
      else
        extent << get_extent_id_from_context_object(context_objects)
      end
      extent
    end



    # ******************************************************************

    def signal_permission_error
      logger.debug "ACCESS DENIED!"
      raise Vigilante::AccessDenied.new
    end


    # ******************************************************************

    #def find_objects
    #  handle_context_for_nested_resources
    #  model = Kernel.const_get(model_name)
    #  objects = model.find_all_by_operator(get_protectee, params)
    #  instance_variable_set "@#{model_name.underscore.pluralize}", objects
    #end
    #
    #
    #def find_object
    #  handle_context_for_nested_resources
    #  model = Kernel.const_get(model_name)
    #  object = model.find_by_operator(get_protectee, params[:id], params)
    #  instance_variable_set "@#{model_name.underscore}", object
    #end


    # returns the model-name for this controller
    # converts
    #    ApplicationController  : Application
    #    ApplicationsController : Application
    #    AccountsController     : Account
    # ...
    def model_name
      controller_name.singularize.camelize
    end

    
#    def to_controller_name(klass)
#      klass_str = klass.is_a?(Class) ? klass.name :
#                  klass.is_a?(String) ? klass :
#                  klass.class.name
#      "#{klass_str.underscore.pluralize}"
#    end


  end
end