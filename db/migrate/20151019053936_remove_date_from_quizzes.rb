class RemoveDateFromQuizzes < ActiveRecord::Migration
  def change
  	remove_column :quizzes, :date
  end
end
