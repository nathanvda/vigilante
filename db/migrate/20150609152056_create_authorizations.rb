class CreateAuthorizations < ActiveRecord::Migration[4.2]
  def change
    create_table :authorizations do |t|
      t.references :operator, references: false
      t.references :ability

      t.timestamps null: false
    end
  end
end
