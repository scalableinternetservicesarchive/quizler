class CreateUsers < ActiveRecord::Migration
  def change
    #drop_table :users if (table_exists? :users)

    create_table :users do |t|
      t.string :username
      t.string :email

      t.timestamps
    end
  end
end
