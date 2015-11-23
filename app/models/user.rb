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
    Friendship.get_friendships_including_pending(self).includes(:user).includes(:friend).map do |friendship|
      friendship.user_id == self.id ? friendship.friend : friendship.user
    end
  end

  def get_friends
    Friendship.get_friends(self).includes(:user).includes(:friend).map do |friendship|
      friendship.user_id == self.id ? friendship.friend : friendship.user
    end
  end

  def get_pending_friends
    Friendship.get_pending_friends(self).includes(:user).includes(:friend).map do |friendship|
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

  def self.search_users_count(current_user, username)
    User.where('username LIKE ? AND id <> ?',"%#{username}%", current_user.id).count
  end

  def self.search_users(current_user, username)
    joined_table = "
    LEFT JOIN
      (SELECT user_id, friend_id, accepted_at
      FROM friendships
      WHERE (friend_id = #{current_user.id} OR user_id = #{current_user.id})) T
    ON T.user_id = users.id OR T.friend_id = users.id"

    User.where('username LIKE ? AND id <> ?',"%#{username}%", current_user.id)
        .joins(joined_table)
        .select('users.id, users.username, users.email, user_id, friend_id, accepted_at')
  end
end
