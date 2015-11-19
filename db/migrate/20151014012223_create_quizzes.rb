class CreateQuizzes < ActiveRecord::Migration


  def change

    drop_table :quizzes if (table_exists? :quizzes)
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.integer :author
      t.string :date

      t.timestamps
    end
  end
end
