class SearchUserResult
  def initialize(current_user, result)
    @current_user = current_user
    @result = result
  end

  def friends?
    !@result.accepted_at.nil?
  end

  # The user sent a friend request to someone else
  def pending_friend?
    if @current_user.id == @result.user_id && @result.accepted_at.nil?
      return true
    end
    false
  end

  # The user received a friend request but didn't accept yet
  def incoming_pending_friend?
    if @current_user.id == @result.friend_id && @result.accepted_at.nil?
      return true
    end
    false
  end

  def accepted_at
    @result.accepted_at
  end

  def username
    @result.username
  end

  def email
    @result.email
  end

  # other user id
  def id
    @result.id
  end

end