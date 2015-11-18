class SearchUserResult
  def initialize(current_user, result)
    @current_user = current_user
    @result = result
  end

  def friends?
    !@result.accepted_at.nil?
  end

  def pending_friend?
    if @current_user.id == @result.user_id && @result.accepted_at.nil?
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

  def id
    @result.id
  end

end