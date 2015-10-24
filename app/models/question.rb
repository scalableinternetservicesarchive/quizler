class Question < ActiveRecord::Base

	validates :question, :answer1, :answer2, :quiz_id, :correct_answer, presence: true
	validates :correct_answer, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 4}
	belongs_to :quiz

	validate :check_option1_and_option2, :check_existence_of_option


	def check_option1_and_option2
		if answer1 == answer2 or answer1 == answer3 or answer1 == answer4 then
			errors.add(:answer1, 'can\'t be the same as another option')
		elsif answer2 == answer3 or answer2 == answer4 then
			errors.add(:answer2, 'can\'t be the same as another option')
		elsif answer3 == answer4 and answer3!=nil and answer4!=nil then
			errors.add(:answer3, 'can\'t be the same as another option')
		end
	end

	def check_existence_of_option
		if answer3 == nil and correct_answer == 3 then
			errors.add(:answer3, 'is empty and correct answer cannot be 3')
		elsif answer4 == nil and correct_answer == 4 then
			errors.add(:answer4, 'is empty and correct answer cannot be 4')
		end
	end
end
