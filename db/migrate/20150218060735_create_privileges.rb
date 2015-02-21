class CreatePrivileges < ActiveRecord::Migration
  def change
    create_table :privileges do |t|
      t.belongs_to :user, index: true
      t.string :privilege, null: false, index: true
      t.string :restrict_to_key, index: true, null: false
      t.string :restrict_to_value, index: true, null: false

      t.timestamps null: false
    end
  end
end
