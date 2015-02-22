class CreatePrivileges < ActiveRecord::Migration
  def change
    create_table :privileges do |t|
      t.belongs_to :user, null: false
      t.string :privilege, null: false
      t.string :restrict_to_key, null: false
      t.string :restrict_to_value, null: false

      t.timestamps null: false
    end
    add_index :privileges, [:user_id, :privilege, :restrict_to_key, :restrict_to_value], unique: true, name: "user_priv"
  end
end
