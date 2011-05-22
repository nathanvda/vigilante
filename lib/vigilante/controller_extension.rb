# Vigilante
#
#   adds db-based authorization

require 'vigilante/authorization'

module Vigilante
  module ControllerExtension  
    def self.included(base)
#      puts "Vigilante is being included in #{base.name}"
      base.extend(ClassMethods)
    end

    module ClassMethods

      # this method should be called inside the ApplicationController, and will add all standard Vigilante behaviour
      def protected_by_vigilante
        # make sure this can only be called from ApplicationController!!
        #logger.debug "called from #{self.to_s}"

        raise VigilanteException.new("protected_by_vigilante must be called from the ApplicationController!") unless self.to_s.split("::").last == "ApplicationController"

        # add ApplicationController - code
        module_eval do
          include Vigilante::Authorization
        end
      end

    end
  end

end


