# == Schema Information
#
# Table name: highscores
#
#  id      :integer          not null, primary key
#  score   :integer
#  user_id :integer          not null
#  quiz_id :integer          not null
#

class Highscore < ActiveRecord::Base
	belongs_to :user
	belongs_to :quiz
	validates :user_id, uniqueness: { :scope => :quiz_id, :message => "has already taken the quiz"}
end
