class AbilityPermission < ActiveRecord::Base
  belongs_to :permission
  belongs_to :ability
end
