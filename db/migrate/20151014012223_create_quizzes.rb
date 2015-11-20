class CreateQuizzes < ActiveRecord::Migration


  def change
    unless (table_exists? :quizzes)
      create_table :quizzes do |t|
        t.string :title
        t.text :description
        t.integer :author
        t.string :date

       t.timestamps
      end
    end
  end
end
