class AddExtentFlagToAbility < ActiveRecord::Migration
  def self.up
    add_column :abilities, :needs_extent, :boolean
  end

  def self.down
    remove_column :abilities, :needs_extent, :boolean
  end
end
