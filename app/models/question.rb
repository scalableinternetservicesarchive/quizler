class Question < ActiveRecord::Base

	validates :question, :answer1, :answer2, presence: true
	
end
