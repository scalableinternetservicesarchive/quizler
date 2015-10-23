class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question
      t.string :answer1
      t.string :answer2
      t.string :answer3
      t.string :answer4
      t.references :quiz, index: true, null: false, foreign_key: true
      t.timestamps
    end
    add_foreign_key :questions, :quizzes, column: :quiz_id
  end
end
