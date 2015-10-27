module CurrentQuiz
	extend ActiveSupport::Concern

	private
	def set_quiz(quiz_id)
		@current_quiz = Quiz.find(quiz_id)
		session[:current_quiz_id] = @current_quiz
		session[:next_question_index] = 0
		@question_counter = 0
	end

	private
	def current_quiz
		Quiz.find(session[:current_quiz_id])
	end

	private


	def current_question
		@questions = Quiz.find(session[:current_quiz_id]).questions
		@current_question = @questions[session[:next_question_index]]
		session[:next_question_index] = session[:next_question_index] +1
		@current_question
	end

	def get_questions
		Quiz.find(session[:current_quiz_id]).questions
	end




end
