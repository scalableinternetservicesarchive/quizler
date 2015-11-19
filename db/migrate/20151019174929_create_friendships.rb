class CreateFriendships < ActiveRecord::Migration
  def change
    #drop_table :friendships if (table_exists? :friendships)

    create_table :friendships do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.references :friend, index: true, null: false
      t.datetime :accepted_at

      t.timestamps
    end

    add_foreign_key :friendships, :users, column: :friend_id
    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
