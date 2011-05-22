class CreateAuthorizations < ActiveRecord::Migration
  def self.up
    create_table :authorizations do |t|
      t.integer :operator_id
      t.integer :ability_id
      t.timestamps
    end
  end

  def self.down
    drop_table :authorizations
  end
end
