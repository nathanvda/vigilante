class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :operator, references: false
      t.references :ability

      t.timestamps null: false
    end
  end
end
