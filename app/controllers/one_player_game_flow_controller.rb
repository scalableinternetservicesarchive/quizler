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
    @current_question = get_next_question
    @correct_answer = @current_question.correct_answer

  end

  def score
    @chosen_answer = params[:format]
    @current_question = current_question
    @correct_answer = @current_question.correct_answer
    @finished = false
    @total_score = get_total_score

    if (get_question_index+1) >= get_questions.count
      @finished = true
    end

  end

  def finale

  end

end
