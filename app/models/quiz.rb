# == Schema Information
#
# Table name: quizzes
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  author      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Quiz < ActiveRecord::Base

	validates :title, :description, :author, presence: true
	has_many :questions, dependent: :destroy
	has_many :highscores, dependent: :destroy

end
