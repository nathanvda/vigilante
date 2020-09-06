class CreateAbilities < ActiveRecord::Migration[4.2]
  def change
    create_table :abilities do |t|
      t.string  :name
      t.string  :description
      t.boolean :needs_extent
      t.integer :importance

      t.timestamps null: false
    end
  end
end
