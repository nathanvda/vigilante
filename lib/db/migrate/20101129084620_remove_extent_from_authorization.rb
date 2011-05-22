class RemoveExtentFromAuthorization < ActiveRecord::Migration
  def self.up
    remove_column :authorizations, :extent
    remove_column :authorizations, :extent_type
  end

  def self.down
    add_column :authorizations, :extent,      :string
    add_column :authorizations, :extent_type, :string
  end
end
