# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  email                  :string(255)      default(""), not null
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: true

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', :foreign_key => 'friend_id'
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :highscores, dependent: :destroy
  has_many :quizzes, class_name: 'Quiz', :foreign_key => 'author_id'

  # def list_friends
  #   friends + inverse_friends
  # end

  def get_friends_and_pending_friends
    Friendship.get_friendships_including_pending(self).map do |friendship|
      friendship.user_id == self.id ? friendship.friend : friendship.user
    end
  end

  def get_friends
    Friendship.get_friends(self).map do |friendship|
      friendship.user_id == self.id ? friendship.friend : friendship.user
    end
  end

  def get_pending_friends
    Friendship.get_pending_friends(self).map do |friendship|
      friendship.user_id == self.id ? friendship.friend : friendship.user
    end
  end

  def pending_friend?(other_user)
    friendship = Friendship.get_friendship(self, other_user)
    friendship.nil? ? false : friendship.accepted_at.nil?
  end

  def friends?(other_user)
    friendship = Friendship.get_friendship(self, other_user)
    friendship.nil? ? false : !friendship.accepted_at.nil?
  end

  def self.search_user(username, current_user)
    User.where('username LIKE ? AND id <> ?',"%#{username}%", current_user.id)
  end
end
