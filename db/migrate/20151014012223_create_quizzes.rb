class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.string :author
      t.string :date

      t.timestamps
    end
  end
end
