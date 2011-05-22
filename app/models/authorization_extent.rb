class AuthorizationExtent < ActiveRecord::Base
  belongs_to :authorization

  def extent
    if extent_objid
      default_extent_class.find_by_id(extent_objid)
    end
  end

  def extent=(ext_label)
    # find asp
    extent_obj = default_extent_class.find_by_id(ext_label)
    if new_record?
      self.extent_objid = extent_obj.id
      self.extent_type = extent_obj.class.name
    else
      set_extent(extent_obj)
    end
  end

  def match_extent(extent_object)
    extent_type == extent_object.class.name && extent_objid == extent_object.id
  end

  def set_extent(extent_object)
    update_attributes(:extent_objid => extent_object.id, :extent_type => extent_object.class.name)
  end
  
  private

  def default_extent_class
    @@default_extent_class ||= Kernel.const_get(::VIGILANTE_CONFIG['default_extent_class'])
  end
end
