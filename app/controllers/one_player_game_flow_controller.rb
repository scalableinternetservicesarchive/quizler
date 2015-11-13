class OnePlayerGameFlowController < ApplicationController
	skip_before_filter :authenticate_user!
  include CurrentQuiz


  def ready
    begin
      @quiz = Quiz.find(params[:quiz_id])
      set_quiz(@quiz)
      @question_count = Question.count(conditions: "quiz_id = #{@quiz.id}")
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :flash => { :alert => "The quiz does not exist" }
    end
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
      increment_correct_answers_count
    end

    @correct_answer_text = current_question.answer1
    if (@correct_answer.to_i == 2)
      @correct_answer_text = current_question.answer2
    elsif (@correct_answer.to_i == 3)
      @correct_answer_text = current_question.answer3
    elsif (@correct_answer.to_i == 4)
      @correct_answer_text = current_question.answer4
    end

    @total_score = get_total_score

  end

  def finale
    begin
      @total_correct_answers_count = get_correct_answers_count
      @questions_count = current_quiz.questions.count
      @total_score = get_total_score
      if user_signed_in?
        cell = Highscore.new(user_id: current_user.id, quiz_id: current_quiz.id, score: @total_score)
        cell.save!
      else
        flash.now[:alert] = "Results not recorded, you're not logged in!" 
      end
    rescue
      flash.now[:alert] = "Results not recorded, you've already taken this quiz!"
    end
    @highscore = Highscore.where(["quiz_id = ?", current_quiz.id]).order("score DESC")
  end


end
