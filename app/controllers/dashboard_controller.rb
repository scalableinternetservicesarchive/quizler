class DashboardController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index

  def index
  	
    @quiz_id = params[:input_quiz_id]

  end

end
