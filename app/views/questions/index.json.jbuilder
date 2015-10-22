json.array!(@questions) do |question|
  json.extract! question, :id, :question, :answer1, :answer2, :answer3, :answer4
  json.url question_url(question, format: :json)
end
