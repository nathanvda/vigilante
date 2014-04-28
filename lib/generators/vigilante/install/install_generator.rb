require 'rails/generators/migration'

module Vigilante
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
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

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template "create_permissions.rb",           "db/migrate/create_permissions.rb"
        migration_template "create_abilities.rb",             "db/migrate/create_abilities.rb"
        migration_template "create_ability_permissions.rb",   "db/migrate/create_ability_permissions.rb"
        migration_template "create_authorizations.rb",        "db/migrate/create_authorizations.rb"
        migration_template "create_authorization_extents.rb", "db/migrate/create_authorization_extents.rb"
        migration_template "add_extent_flag_to_ability.rb",   "db/migrate/add_extent_flag_to_ability.rb"
        migration_template "add_importance_to_abilities.rb",  "db/migrate/add_importance_to_abilities.rb"
      end

    end
  end
end