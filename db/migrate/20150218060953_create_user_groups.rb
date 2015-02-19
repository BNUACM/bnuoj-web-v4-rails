class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.string :groupname, null: false

      t.timestamps null: false
    end

    create_table :user_user_groups, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :user_group, index: true
    end
  end
end
