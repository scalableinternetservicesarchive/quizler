class Question < ActiveRecord::Base

	validates :question, :answer1, :answer2, :quiz_id, presence: true
	belongs_to :quiz
	
end
