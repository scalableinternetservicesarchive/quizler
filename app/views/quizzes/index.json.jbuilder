json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :title, :description, :author, :date
  json.url quiz_url(quiz, format: :json)
end
