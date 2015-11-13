module CurrentQuiz
	extend ActiveSupport::Concern

	private
	def set_quiz(quiz)
		@current_quiz = quiz
		session[:current_quiz_title] = @current_quiz.title
		session[:current_quiz_id] = @current_quiz.id
		session[:next_question_index] = -1
		session[:total_score] = 0
		@question_counter = 0
		session[:@correct_answers_count] = 0
	end

	private
	def current_quiz_id
		session[:current_quiz_id]
	end

	def current_quiz_title
		session[:current_quiz_title]
	end

	private
	def get_next_question(questions)
		session[:next_question_index] = session[:next_question_index] +1
		@current_question = questions[session[:next_question_index]]
		@current_question
	end

	private
	def current_question(questions)
		questions[session[:next_question_index]]
	end

	def get_questions
		Question.where(quiz_id: session[:current_quiz_id])
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


	private
	def increment_correct_answers_count
		session[:@correct_answers_count] = (session[:@correct_answers_count]).to_i + 1
	end

	private
	def get_correct_answers_count
		session[:@correct_answers_count]
	end

end
