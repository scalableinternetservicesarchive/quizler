class DashboardController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index

  def index
  	
    @quiz_id = params[:input_quiz_id]


  end


  def fetch_questions
    #quiz_id = params[:quiz_id]
    #console.log("Test")

  end
end
