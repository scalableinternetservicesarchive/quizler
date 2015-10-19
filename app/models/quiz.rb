class Quiz < ActiveRecord::Base

	validates :title, :description, presence: true

end
