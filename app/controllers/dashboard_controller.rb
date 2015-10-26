class DashboardController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index

  def index

  end


  def fetch_questions
    #quiz_id = params[:quiz_id]
    #console.log("Test")
    @questions = Question.find(quiz_id: '4')

  end
end
