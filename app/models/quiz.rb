class Quiz < ActiveRecord::Base

	validates :title, :description, :author, presence: true
	has_many :questions, dependent: :destroy

end
