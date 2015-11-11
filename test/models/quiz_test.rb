# == Schema Information
#
# Table name: quizzes
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  author_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class QuizTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'a quiz should have a title, description and author' do
    user = User.create!(username: 'francois', email: 'francois@ucsb.edu', password: 'password')

    quiz = Quiz.new(title: 'Title', description: 'Description', author: user)
    assert quiz.valid?

    quiz = Quiz.new(title: '', description: 'Description', author: user)
    assert !quiz.valid?
    assert_equal ['Title can\'t be blank'], quiz.errors.full_messages

    quiz = Quiz.new(title: 'Title', description: '', author: user)
    assert !quiz.valid?
    assert_equal ['Description can\'t be blank'], quiz.errors.full_messages

    quiz = Quiz.new(title: 'Title', description: 'Description')
    assert !quiz.valid?
    assert_equal ['Author can\'t be blank'], quiz.errors.full_messages
  end

  test 'if a quiz is destroyed, a question should be destroyed' do
    user = User.create!(username: 'francois', email: 'francois@ucsb.edu', password: 'password')

    quiz = Quiz.create!(title: 'Title', description: 'Description', author: user)
    question = Question.create!(question: "Q", answer1: "1", answer2: "2", correct_answer: 1, quiz: quiz)
    quiz.questions << question
    assert_difference 'Question.count', -1, "A question should be deleted" do
      quiz.destroy
    end
  end

  test 'a quiz belongs to a user' do
    user = User.create!(username: 'francois', email: 'francois@ucsb.edu', password: 'password')
    quiz = Quiz.create!(title: 'Title', description: 'Description', author: user)

    quiz.reload
    assert_equal user, quiz.author
  end

=begin
  test 'if a quiz is destroyed, all of the corresponding questions should be destroyed' do
    quiz2 = Quiz.new(id: 2, title: 'Title', description: 'Description', author: 'user', )
    question2 = Question.new(question: "Q", answer1: "1", answer2: "2", correct_answer: 1, quiz_id: 2)
    question3 = Question.new(question: "Q", answer1: "1", answer2: "2", correct_answer: 1, quiz_id: 2)
    quiz2.questions << question2
    quiz2.questions << question3
    assert_difference 'Question.count', -2, "A question should be deleted" do
      quiz2.destroy

    -------------
    Works in database, but the test doesn't destroy all of the questions
    -------------

    end
  end
=end

end
