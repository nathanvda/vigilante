class CreateAbilityPermissions < ActiveRecord::Migration[4.2]
  def change
    create_table :ability_permissions do |t|
      t.references :ability
      t.references :permission

      t.timestamps null: false
    end
  end
end
