class Ability < ActiveRecord::Base
  has_many :ability_permissions
  has_many :permissions, :through => :ability_permissions

  accepts_nested_attributes_for :permissions
  accepts_nested_attributes_for :ability_permissions

  scope :that_need_extent, lambda { where('needs_extent=?', true)}
end
