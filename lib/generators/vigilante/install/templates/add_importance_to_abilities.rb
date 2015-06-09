class CreateAbilityPermissions < ActiveRecord::Migration
  def self.change
    change_table :abilities do |t|
      t.integer :importance
    end
  end
end