# == Schema Information
#
# Table name: quizzes
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  author_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Quiz < ActiveRecord::Base

	validates :title, :description, :author, presence: true
	has_many :questions, dependent: :destroy
	has_many :highscores, dependent: :destroy
	belongs_to :author, class_name: 'User'
end
