class Ability < ActiveRecord::Base
  has_many :ability_permissions
  has_many :permissions, :through => :ability_permissions

  scope :that_need_extent, lambda { where('needs_extent=?', true)}
end
