class CreateAbilityPermissions < ActiveRecord::Migration
  def change
    create_table :ability_permissions do |t|
      t.references :abilities
      t.references :permissions

      t.timestamps null: false
    end
  end
end
