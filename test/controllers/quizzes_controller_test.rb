require 'test_helper'

class QuizzesControllerTest < ActionController::TestCase
  setup do
    sign_in_as_user

    @quiz = quizzes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quizzes)
  end

 # test "should get new" do
 #   get :new
 #   assert_response :success
 # end

  test "should create quiz" do
    assert_difference('Quiz.count') do
      post :create, quiz: { title: @quiz. title, author_id: @quiz.author_id, description: @quiz.description }
    end

    assert_redirected_to quiz_path(assigns(:quiz))
  end

  test "should show quiz" do
    get :show, id: @quiz
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quiz
    assert_response :success
  end

  test "should update quiz" do
    patch :update, id: @quiz, quiz: {  title: @quiz. title, author: @quiz.author, description: @quiz.description }
    assert_redirected_to quiz_path(assigns(:quiz))
  end

  test "should destroy quiz" do
    assert_difference('Quiz.count', -1) do
      delete :destroy, id: @quiz
    end

    assert_redirected_to quizzes_path
  end
end
