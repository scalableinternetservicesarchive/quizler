class OnePlayerGameFlowController < ApplicationController


  def ready
    @quiz_id = params[:quiz_id]
    @current_quiz = Quiz.find(params[:quiz_id])
    @questions = @current_quiz.questions

  end

  def question_option

  end

  def score

  end

  def finale

  end

end
