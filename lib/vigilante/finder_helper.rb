module Vigilante
  module FinderHelper

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

    end

  end
end