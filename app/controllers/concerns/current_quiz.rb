module CurrentQuiz
	extend ActiveSupport::Concern

	private
	def set_quiz(quiz_id)
		@current_quiz = Quiz.find(quiz_id)
		session[:current_quiz_id] = @current_quiz
		session[:next_question_index] = -1
		session[:total_score] = 0
		@question_counter = 0
	end

	private
	def current_quiz
		Quiz.find(session[:current_quiz_id])
	end

	private
	def get_next_question
		@questions = Quiz.find(session[:current_quiz_id]).questions
		session[:next_question_index] = session[:next_question_index] +1
		@current_question = @questions[session[:next_question_index]]
		@current_question
	end

	private
	def current_question
		@questions = Quiz.find(session[:current_quiz_id]).questions
		@current_question = @questions[session[:next_question_index]]
		@current_question
	end

	def get_questions
		Quiz.find(session[:current_quiz_id]).questions
	end

	def get_question_index
		session[:next_question_index]
	end

	private
	def increment_score(score)
		session[:total_score] = session[:total_score] + score
	end

	private
	def get_total_score
		session[:total_score]
	end

	private
	def set_chosen_answer(ans)
		session[:chosen_answer] = ans
	end

	private
	def get_chosen_answer
		session[:chosen_answer]
	end



end
