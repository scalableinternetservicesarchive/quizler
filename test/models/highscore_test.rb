require 'test_helper'

class HighscoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

	test 'a_user_should_be_able_to_save_a_score' do
		user = User.new(username: 'whatever', email: 'hello@ucsb.edu', password: 'password')
		quiz = Quiz.new(title: 'Title', description: 'Description', author: 1)
		score = 20

		highscore = Highscore.new(user_id: user.id, quiz_id: quiz.id, score: score)
		assert highscore.valid?
	end

	test 'a_user_should_only_have_one_score_in_each_quiz' do

		user = User.create(username: 'whatever', email: 'hello@ucsb.edu', password: 'password')
		quiz = Quiz.create(title: 'Title', description: 'Description', author: 1)

		highscore1 = Highscore.new(user_id: user.id, quiz_id: quiz.id, score: 20)
		highscore2 = Highscore.new(user_id: user.id, quiz_id: quiz.id, score: 20)

		highscore1.save

		assert !highscore2.valid?
		assert_equal ["User has already taken the quiz"], highscore2.errors.full_messages
		
	end

end
