class CreateAbilityPermissions < ActiveRecord::Migration
  def self.up
    create_table :ability_permissions do |t|
      t.integer :ability_id
      t.integer :permission_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ability_permissions
  end
end
