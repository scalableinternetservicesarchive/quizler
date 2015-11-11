require 'test_helper'

class QuizzesControllerTest < ActionController::TestCase
  setup do
    @current_user = sign_in_as_user

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
    patch :update, id: @quiz, quiz: {  title: @quiz. title, author_id: @quiz.author_id, description: @quiz.description }
    assert_redirected_to quiz_path(assigns(:quiz))
  end

  test "should destroy quiz" do
    assert_difference('Quiz.count', -1) do
      delete :destroy, id: @quiz
    end

    assert_redirected_to quizzes_path
  end

  test 'I cannot edit a quiz that I did not create' do
    other_user = User.create!(username: 'francois', email: 'francois@ucsb.edu', password: 'password')
    quiz = Quiz.create!(title: 'Title', description: 'Description', author: other_user)

    get :edit, id: quiz.id

    assert_redirected_to quizzes_browse_path
    assert_equal 'You\'re not the author of this quiz and not allowed to access it.', flash[:alert]
  end

  test 'I cannot update a quiz that I did not create' do
    other_user = User.create!(username: 'francois', email: 'francois@ucsb.edu', password: 'password')
    quiz = Quiz.create!(title: 'Title', description: 'DescriptionOld', author: other_user)

    patch :update, id: quiz.id, quiz: {  title: 'New Title', author_id: @current_user.id, description: 'Description' }

    assert_redirected_to quizzes_browse_path
    assert_equal 'You\'re not the author of this quiz and not allowed to access it.', flash[:alert]
    quiz.reload
    assert_equal 'Title', quiz.title
    assert_equal other_user.id, quiz.author_id
    assert_equal 'DescriptionOld', quiz.description

  end

  test 'I cannot see a quiz that I did not create' do
    other_user = User.create!(username: 'francois', email: 'francois@ucsb.edu', password: 'password')
    quiz = Quiz.create!(title: 'Title', description: 'Description', author: other_user)

    get :show, id: quiz.id

    assert_redirected_to quizzes_browse_path
    assert_equal 'You\'re not the author of this quiz and not allowed to access it.', flash[:alert]
  end

  test 'I cannot destroy a quiz that I did not create' do
    other_user = User.create!(username: 'francois', email: 'francois@ucsb.edu', password: 'password')
    quiz = Quiz.create!(title: 'Title', description: 'Description', author: other_user)

    assert_no_difference 'Quiz.count' do
      delete :destroy, id: quiz.id
    end

    assert_redirected_to quizzes_browse_path
    assert_equal 'You\'re not the author of this quiz and not allowed to access it.', flash[:alert]
  end
end
