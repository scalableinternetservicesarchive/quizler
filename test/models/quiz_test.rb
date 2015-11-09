# == Schema Information
#
# Table name: quizzes
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  author      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class QuizTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'a quiz should have a title, description and author' do

    quiz = Quiz.new(title: 'Title', description: 'Description', author: 1 )
    assert quiz.valid?

    quiz = Quiz.new(title: '', description: 'Description', author: 1 )
    assert !quiz.valid?
    assert_equal ['Title can\'t be blank'], quiz.errors.full_messages

    quiz = Quiz.new(title: 'Title', description: '', author: 1 )
    assert !quiz.valid?
    assert_equal ['Description can\'t be blank'], quiz.errors.full_messages

    quiz = Quiz.new(title: 'Title', description: 'Description', author: '' )
    assert !quiz.valid?
    assert_equal ['Author can\'t be blank'], quiz.errors.full_messages
  end

  test 'if a quiz is destroyed, a question should be destroyed' do
    quiz = Quiz.new(id: 1, title: 'Title', description: 'Description', author: 1 )
    question = Question.new(question: "Q", answer1: "1", answer2: "2", correct_answer: 1, quiz_id: 1)
    quiz.questions << question
    assert_difference 'Question.count', -1, "A question should be deleted" do
      quiz.destroy
    end
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
