class CreateAuthorizationExtents < ActiveRecord::Migration
  def change
    create_table :authorization_extents do |t|
      t.references :authorizations
      t.string     :extent_type
      t.integer    :extent_objid

      t.timestamps null: false
    end
  end
end
