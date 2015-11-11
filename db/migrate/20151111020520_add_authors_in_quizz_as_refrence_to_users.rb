class AddAuthorsInQuizzAsRefrenceToUsers < ActiveRecord::Migration
  def change
    rename_column :quizzes, :author, :author_id
    add_index :quizzes, :author_id
    add_foreign_key :quizzes, :author_id
  end
end
