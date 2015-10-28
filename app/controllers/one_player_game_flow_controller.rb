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
    @current_question = current_question

    @correct_answer = @current_question.correct_answer
    @chosen_answer = params[:format]

    @finished = false
    if (get_question_index+1) >= get_questions.count
      @finished = true
    end

    @correct_answer_points = 0
    if @correct_answer.to_i == @chosen_answer.to_i
      @correct_answer_points = 10
      increment_score(@correct_answer_points)
    end
    @total_score = get_total_score

  end

  def finale

  end

end
