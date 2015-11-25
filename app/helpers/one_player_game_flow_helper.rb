module OnePlayerGameFlowHelper

  def cache_key_for_current_question(question)
    "one_player_game_flow/current_question/#{question.id}/#{question.updated_at}"
  end
end
