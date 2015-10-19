class RemoveDateFieldInDb < ActiveRecord::Migration

	def up

	end

  	def down
 		remove_column :quizzes, :date
	end 
end
