class FriendshipsController < ApplicationController

  def search_user

  end

  def fetch_users
    username = params[:username]
    @users = User.where('username LIKE ? AND id <> ?',"%#{username}%", current_user.id).to_a

    respond_to do |format|
      format.js {}
    end
  end

  def create
    pending_friend = User.find_by_id(params[:user_id])

    respond_to do |format|
      if pending_friend.nil?
        format.json { render json: {status: 'error', errorType: 'userInexistant'}}
      else
        new_friendship = Friendship.new(user: current_user, friend: pending_friend)

        if new_friendship.save
          format.json { render json: {status: 'success', user: pending_friend.id} }
        else
          format.json { render json: {status: 'error', errorType: 'cannotSave', user: pending_friend.id, messages: new_friendship.errors.full_messages}}
        end
      end
    end
  end
end
