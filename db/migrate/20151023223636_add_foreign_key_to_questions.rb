class AddForeignKeyToQuestions < ActiveRecord::Migration
  def change
    add_foreign_key :questions, :quizzes
  end
end
