# == Schema Information
#
# Table name: friendships
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  friend_id   :integer          not null
#  accepted_at :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validate :validation_uniqueness_of_friendship

  # validates_uniqueness_of :user_id, scope: [:friend_id], message: 'Friendship already exists'

  def self.get_friendships_including_pending(user)
    where('user_id = ? OR friend_id = ?', user, user)
  end

  def self.get_friends(user)
    where('(user_id = ? OR friend_id = ?) AND accepted_at IS NOT NULL', user, user)
  end

  def self.get_pending_friends(user)
    where('(user_id = ? OR friend_id = ?) AND accepted_at IS NULL', user, user)
  end

  def self.get_friendship(user_1, user_2)
    where('(user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)', user_1, user_2, user_2, user_1).first
  end

  private

  def validation_uniqueness_of_friendship
    if self.new_record? and !Friendship.get_friendship(user_id, friend_id).nil?
      errors.add(:base, 'Friendship already exists')
    end
  end

end
