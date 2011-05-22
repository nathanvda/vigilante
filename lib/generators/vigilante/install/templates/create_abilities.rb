class CreateAbilities < ActiveRecord::Migration
  def self.up
    create_table :abilities do |t|
      t.string  :name
      t.string  :description
      t.boolean :needs_extent      
      t.timestamps
    end
  end

  def self.down
    drop_table :abilities
  end
end
