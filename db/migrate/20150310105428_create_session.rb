class CreateSession < ActiveRecord::Migration
  def change
    create_table :sessions, id: false do |t|
      t.string :token, null: false
      t.string :username, null: false
      t.string :ipaddr, null: false
      t.datetime :expire_at, null: false
      t.boolean :cksave, default: 0
    end
    add_index :sessions, :token, unique:true
  end
end
