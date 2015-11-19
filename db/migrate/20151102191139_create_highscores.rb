class CreateHighscores < ActiveRecord::Migration
  def change
    #create_table(:highscores, id: false, primary_key: 'user_id' ) do |t|
    #drop_table :highscores if (table_exists? :highscores)

    create_table(:highscores) do |t|

      t.integer :score

      t.references :user, index: true, null: false, foreign_key: true
      t.references :quiz, index: true, null: false, foreign_key: true
      t.timestamp
    end
    add_foreign_key :highscores, :users, column: :user_id
    add_foreign_key :highscores, :quizzes, column: :quiz_id
  end
end

