class OnePlayerGameFlowController < ApplicationController
	include CurrentQuiz

  def ready
  	set_quiz(Quiz.find(params[:quiz_id]))
  	@quiz = current_quiz
    @questions = @quiz.questions
  end

  def question_option
  	@quiz = current_quiz
    @questions = get_questions
    @current_question = current_question



  end

  def score
    @finished = false

    if get_question_index >= get_questions.count
      @finished = true
    end
  end

  def finale

  end

end
