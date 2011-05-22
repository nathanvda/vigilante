class AddAuthorizationExtent < ActiveRecord::Migration
  def self.up
    create_table :authorization_extents do |t|
      t.integer :authorization_id
      t.string  :extent_type
      t.integer :extent_objid

      t.timestamps
    end
  end

  def self.down
    drop_table :authorization_extents
  end
end
