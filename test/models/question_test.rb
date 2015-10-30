# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  question       :string(255)
#  answer1        :string(255)
#  answer2        :string(255)
#  answer3        :string(255)
#  answer4        :string(255)
#  quiz_id        :integer          not null
#  created_at     :datetime
#  updated_at     :datetime
#  correct_answer :integer
#

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'a question should have a question, at least two options, an answer, and a foreign key to quiz' do
    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert question.valid?

    question = Question.new(question: '', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Question can\'t be blank'], question.errors.full_messages

    question = Question.new(question: 'Q1', answer1: '', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer1 can\'t be blank'], question.errors.full_messages

    question = Question.new(question: 'Q1', answer1: 'option1', answer2: '', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer2 can\'t be blank'], question.errors.full_messages

    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: '', correct_answer: 1)
    assert !question.valid?
    assert_equal ['Quiz can\'t be blank'], question.errors.full_messages
  end

  test 'correct answer is in the interval [1,4]' do
    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert question.valid?

    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: -1)
    assert !question.valid?

    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 5)
    assert !question.valid?
  end

  test 'options must be unique for a question' do
    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert question.valid?

    #Option1
    question = Question.new(question: 'Q1', answer1: 'option', answer2: 'option', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer1 can\'t be the same as another option'], question.errors.full_messages

    question = Question.new(question: 'Q1', answer1: 'option', answer2: 'option2', answer3: 'option', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer1 can\'t be the same as another option'], question.errors.full_messages

    question = Question.new(question: 'Q1', answer1: 'option', answer2: 'option2', answer3: 'option3', answer4: 'option', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer1 can\'t be the same as another option'], question.errors.full_messages

    question = Question.new(question: 'Q1', answer1: 'option', answer2: 'option', answer3: 'option', answer4: 'option', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer1 can\'t be the same as another option'], question.errors.full_messages

    #Option2
    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option', answer3: 'option', answer4: 'option4', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer2 can\'t be the same as another option'], question.errors.full_messages

    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option', answer3: 'option3', answer4: 'option', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer2 can\'t be the same as another option'], question.errors.full_messages

    #Option3
    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option', answer4: 'option', quiz_id: 1, correct_answer: 1)
    assert !question.valid?
    assert_equal ['Answer3 can\'t be the same as another option'], question.errors.full_messages
  end

  #QUESTION from Silje: is an empty option '' or nil? Might have to change validation in question model
  test 'can only choose correct_answer if the option is filled out' do
    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: 'option4', quiz_id: 1, correct_answer: 4)
    assert question.valid?

    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: nil, answer4: nil, quiz_id: 1, correct_answer: 3)
    assert !question.valid?
    assert_equal ['Answer3 is empty and correct answer cannot be 3'], question.errors.full_messages

    question = Question.new(question: 'Q1', answer1: 'option1', answer2: 'option2', answer3: 'option3', answer4: nil, quiz_id: 1, correct_answer: 4)
    assert !question.valid?
    assert_equal ['Answer4 is empty and correct answer cannot be 4'], question.errors.full_messages
  end


end
