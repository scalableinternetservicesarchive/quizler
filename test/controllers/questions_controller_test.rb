require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @question = questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:questions)
  end

#  test "should get new" do
#    get :new
#    assert_response :success
#  end

  test "should create question" do
    assert_difference('Question.count') do
      post :create, question: { answer1: @question.answer1, answer2: @question.answer2, answer3: @question.answer3, answer4: @question.answer4, question: @question.question, quiz_id: @question.quiz_id, correct_answer: @question.correct_answer }
    end

    assert_redirected_to quiz_path(Quiz.find(@question.quiz_id))
  end

  test "should show question" do
    get :show, id: @question
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @question
    assert_response :success
  end

  test "should update question" do
    patch :update, id: @question, question: { answer1: @question.answer1, answer2: @question.answer2, answer3: @question.answer3, answer4: @question.answer4, question: @question.question, quiz_id: @question.quiz_id, correct_answer: @question.correct_answer}
    assert_redirected_to quiz_path(Quiz.find(@question.quiz_id))
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete :destroy, id: @question
    end
    assert_redirected_to quiz_path(Quiz.find(@question.quiz_id))
  end
end
