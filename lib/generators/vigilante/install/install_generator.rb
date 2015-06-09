module Vigilante
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      desc "This generator installs the default config file, and glue code into application-controller; which you can edit"


      def copy_config_file
        copy_file "vigilante_config.yml", "config/vigilante_config.yml"
      end

      def adapt_application_controller
#        inject_into_class "app/controllers/application_controller.rb", ApplicationController do <<CODE
        inject_into_file "app/controllers/application_controller.rb", :after => "class ApplicationController < ActionController::Base"  do <<CODE

  protected_by_vigilante

  #----------------------------------
  # Begin Vigilante glue code
  #
  #     note: you can easily rename the functions, the function-names are configured in the
  #           the @vigilante_config.yml@ configuration file.
  #
  #----------------------------------


  # retrieves the current context, this is called at the top of the @check_permissions@ function.
  # This means that inside a nested resource, the nested resources should be retrieved before the
  # @check_permissions@ is called, e.g. in a @:before_filter@. This is considered good practice anyway.
  #
  def current_context
    # example :
    # context = @blog || @blogs
    # context = [context] unless context.nil? || context.is_a?(Array)
    nil
  end


  # retrieves the id from your chosen context-object. You should rename to something more meaningful
  # like
  #
  #    get_blog_id_from_context_object
  #
  # As the extents are stored by id, this is used to check which permissions are valid for you (in this context).
  #
  def get_context_id_from_context_object(obj)
=begin
    # example
    logger.debug "get_asp_id_from_context_object received \#{obj.inspect}"
    blog_id = if obj.is_a?(Blog)
      obj.id
    elsif obj.is_a?(Post) || obj.is_a?(Author)
      obj.blog_id
    else
      0
    end
    blog_id.to_s
=end
    "0"
  end

  # this is used by the finders, to allow automatic finding of the resources, if needed
  # You should rename this, for clarity sake, to which parameter you look for (nested resource)
  # In this case:
  #    find_blog_by_blog_id
  #
  #
  def find_context_by_context_id
=begin
    @blog = Blog.find_by_id(params[:blog_id]) if params[:blog_id].present?
=end
  end

  #----------------------------------
  # End Vigilante glue code
  #----------------------------------

CODE
        end
      end
    end
  end
end