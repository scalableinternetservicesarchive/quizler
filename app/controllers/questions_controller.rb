class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  respond_to :html


  def index
    @questions = Question.all
    respond_with(@questions)
  end

  def show
    respond_with(@question)
  end

  def new
    @question = Question.new
    @question.quiz_id = params[:quiz_id]
    respond_with(@quiz)
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @quiz = Quiz.find(@question.quiz_id)
    @question.save
    respond_to do |format|
      if @question.save
        format.html { redirect_to @quiz, notice: 'Question was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quiz }
      else
        format.html { render action: 'new' }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:question, :answer1, :answer2, :answer3, :answer4, :quiz_id)
    end
end
