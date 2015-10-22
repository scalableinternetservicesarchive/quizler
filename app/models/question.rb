class Question < ActiveRecord::Base

	validates :question, :answer1, :answer2, :quiz_id, :correct_answer, presence: true
	validates :correct_answer, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4}
	belongs_to :quiz
	
end
