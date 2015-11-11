json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :title, :description, :author_id, :date
  json.url quiz_url(quiz, format: :json)
end
