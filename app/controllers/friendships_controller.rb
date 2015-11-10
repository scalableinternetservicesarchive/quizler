class FriendshipsController < ApplicationController
  require 'will_paginate/array'


  def search
  end

  def fetch_users
    username = params[:username]
    @users_sql = User.where('username LIKE ? AND id <> ?',"%#{username}%", current_user.id).to_a
    @users = @users_sql.paginate(:page => params[:page], :per_page => 30)


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

  def friendship_requests
    @incoming_pending_friendships = Friendship.get_incoming_pending_friendships_for(current_user)
  end

  def accept_friendship
    requested_friendship = Friendship.find_by_id(params[:friendship_id])

    respond_to do |format|
      if requested_friendship.nil?
        format.json { render json: {status: 'error', errorType: 'friendshipInexistant'}}
      elsif !requested_friendship.accepted_at.nil?
        format.json { render json: {status: 'error', errorType: 'friendshipAccepted'}}
      else

        if requested_friendship.update_attributes(accepted_at: DateTime.now)
          format.json { render json: {status: 'success', friendship: requested_friendship.id} }
        else
          format.json { render json: {status: 'error', errorType: 'cannotSave', friendship: requested_friendship.id, messages: requested_friendship.errors.full_messages}}
        end
      end
    end
  end

  def index
    @friends = current_user.get_friends
  end
end
