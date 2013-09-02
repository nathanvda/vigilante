class AbilityPermission < ActiveRecord::Base
  belongs_to :permission
  belongs_to :ability

  accepts_nested_attributes_for :permission
end
