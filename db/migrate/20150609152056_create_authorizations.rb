class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :operators, references: false
      t.references :abilities

      t.timestamps null: false
    end
  end
end
