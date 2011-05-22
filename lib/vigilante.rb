require 'vigilante/controller_extension'
require 'vigilante/active_record_extensions'

module Vigilante

  #define exceptions
  module ExceptionsMixin
    def initialize(str)
      super("Vigilante: " + str)
    end
  end
  class ArgumentError < ::ArgumentError #:nodoc:
    include ExceptionsMixin
  end

  class AccessDenied < ::StandardError #:nodoc:
    include ExceptionsMixin
    def initialize(str='Access denied: you do not have the right permissions for the requested action.')
      super(str)
    end
  end  


  class Engine < ::Rails::Engine

    # configure our plugin on boot
    initializer "vigilante.initialize" do |app|
      # mixin our code
      ActionController::Base.send(:include, Vigilante::ControllerExtension)
      ActiveRecord::Base.send(:include, Vigilante::ActiveRecordExtensions)

      #load configuration files if they are available
      vigilante_config_file         = File.join("#{Rails.root.to_s}", 'config', 'vigilante_config.yml')
      default_vigilante_config_file = File.join(File.dirname(__FILE__), 'config', 'vigilante_config.yml')
      default_vigilante_config_file = vigilante_config_file if File.exist?(vigilante_config_file)

      if File.exist?(default_vigilante_config_file)
        Rails.logger.debug "define VIGILANTE_CONFIG"
        raw_config = File.read(default_vigilante_config_file)
        ::VIGILANTE_CONFIG = YAML.load(raw_config)["#{Rails.env}"]
      else
        raise Vigilante::ArgumentError.new("The vigilante_config.yml is missing. Path=#{default_vigilante_config_file} Did you run the generator vigilante:install? ")
      end
    end

  end
end