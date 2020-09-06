class CreatePermissions < ActiveRecord::Migration[4.2]
  def change
    create_table :permissions do |t|
      t.string :allowed_action

      t.timestamps null: false
    end
  end
end
