class Authorization < ActiveRecord::Base
  belongs_to :operator, :class_name => ::VIGILANTE_CONFIG['current_user_class'].to_s
  belongs_to :ability

  has_many :authorization_extents, :dependent => :delete_all
  accepts_nested_attributes_for :authorization_extents, :reject_if => proc { |x| x[:extent].blank? && x[:extent_objid].blank? }, :allow_destroy => true


  def match_extent(extent_object)
    extents_count = authorization_extents.count
    return true if extents_count == 0 && extent_object.blank?

    return false if ((extents_count == 0 && extent_object.present?) ||
                     (extents_count > 0  && extent_object.blank?))

    authorization_extents.each do |extent|
      return true if extent.match_extent(extent_object)
    end
    false
  end


  def add_extent(extent_object)
    unless extent_object.nil? || match_extent(extent_object)
      new_extent = authorization_extents.build
      new_extent.set_extent(extent_object)
      new_extent.save
    end
  end
  
  def has_extent?
    authorization_extents.count > 0
  end
end
