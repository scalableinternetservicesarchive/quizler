module QuizzesHelper
  def cache_key_for_quiz_table(page)
    ("quizzes/#{Quiz.maximum(:updated_at).to_s}/#{page}")
  end

  def cache_key_for_my_quiz_table(current_user, page)
    sql = "SELECT MAX(updated_at) AS max_result FROM quizzes WHERE author_id = #{current_user.id}"
    max_updated_at_result = Quiz.connection.execute(sql)
    updated_at = max_updated_at_result.first['max_result']
    ("quizzes/#{current_user.id}/#{updated_at}/#{page}")
  end
end
