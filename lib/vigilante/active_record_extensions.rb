require 'vigilante/watched_operator'

module Vigilante
  module ActiveRecordExtensions

    def self.included(base)
#      puts "Vigilante::FinderHelper is being included in #{base.name}"
      base.extend ClassMethods
    end

    module ClassMethods

      def operator_extent(operator)
        extent = operator.permits.get_extent_of(self.name.underscore.pluralize, :show)
        if extent.include?('*')
          nil
        else
          # fix: if extent is empty return 0 which would can be used in sql and not match anything
          extent.size == 0 ? '0' : extent.join(',')
        end
      end

      # run this in the model that is the operator or user or ...
      def authorisations_handled_by_vigilante
        module_eval do
          include Vigilante::WatchedOperator
        end
      end

    end

  end
end