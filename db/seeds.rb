# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

heather_user = User.create!(username: 'Heather', email: 'heather@whatever.com', password: 'awesomepassword')
User.create!(username: 'Jeff', email: 'jeff@whatever.com', password: 'awesomepassword')
User.create!(username: 'Laura', email: 'laura@whatever.com', password: 'awesomepassword')
User.create!(username: 'Steve', email: 'steve@whatever.com', password: 'awesomepassword')

Quiz.create!(title: 'Soccer Quiz', description: 'A quiz about soccer', author: 'Heather')
Quiz.create!(title: 'Beer Quiz', description: 'A quiz about beer', author: 'Jeff')

Question.create!(question: 'Where is David Beckham from?', answer1: 'Spain', answer2: 'England', answer3: 'Norway', answer4: 'France', quiz_id: 1, correct_answer: 2)
Question.create!(question: 'In which league are Arsenal playing?', answer1: 'Premier League', answer2: 'La Liga', quiz_id: 1, correct_answer: 1)
Question.create!(question: 'Who won the World Cup in 2002?', answer1: 'France', answer2: 'Germany', answer3: 'Brazil', quiz_id: 1, correct_answer: 3)
Question.create!(question: 'What do the players kick?', answer1: 'Girls', answer2: 'Boys', answer3: 'Balls', answer4: 'Nuts', quiz_id: 1, correct_answer: 3)

Question.create!(question: 'Where can you buy a beer?', answer1: 'At the laundry', answer2: 'At a bar', answer3: 'In the kindergarden', quiz_id: 2, correct_answer: 2)
Question.create!(question: 'Which is NOT a beer?', answer1: 'Duff', answer2: 'Corona', answer3: 'Quizler', answer4: 'Heineken', quiz_id: 2, correct_answer: 3)

# Create friends and friend requests to/from heather

number_users_without_friends = 10

number_users_without_friends.times do
  username = Faker::Internet.user_name
  email = "#{username}@whatsup.com"
  user = User.new(username: username, email: email, password: 'awesomepassword')
  user.save if user.valid?
end

max_friends_for_heather = 10
max_friend_requests_for_or_from_heather = 5

max_friends_for_heather.times do
  username = Faker::Internet.user_name
  email = "#{username}@whatsup.com"
  new_user = User.new(username: username, email: email, password: 'awesomepassword')

  if new_user.valid?
    new_user.save
    direction_friendship = Random.rand(2)

    if direction_friendship == 1
      Friendship.create(user_id: new_user.id, friend_id: heather_user.id, accepted_at: DateTime.now)
    else
      Friendship.create(friend_id: new_user.id, user_id: heather_user.id, accepted_at: DateTime.now)
    end
  end
end

max_friend_requests_for_or_from_heather.times do
  username = Faker::Internet.user_name
  email = "#{username}@whatsup.com"
  new_user = User.new(username: username, email: email, password: 'awesomepassword')

  if new_user.valid?
    new_user.save
    direction_friendship = Random.rand(2)

    if direction_friendship == 1
      Friendship.create(user_id: new_user.id, friend_id: heather_user.id)
    else
      Friendship.create(friend_id: new_user.id, user_id: heather_user.id)
    end
  end
end

number_quizzes = 1000
number_questions = 10

number_quizzes.times do |i|
  title = Faker::Lorem.sentence
  description = Faker::Lorem.sentence
  author = User.find(Random.rand(1..number_users_without_friends)).username
  #new_quiz = Quiz.create(title: title, description: description, author: author)
  Quiz.connection.execute "INSERT INTO quizzes (title, description, author) VALUES ('#{title}', '#{description}', '#{author}')"

  number_questions.times do
    question = Faker::Lorem.sentence
    answer1 = Faker::Lorem.word
    answer2 = Faker::Lorem.word
    answer3 = Faker::Lorem.word
    answer4 = Faker::Lorem.word
    correct_answer = Random.rand(1..4)

    Question.connection.execute "INSERT INTO questions (question, answer1, answer2, answer3, answer4, correct_answer, quiz_id) VALUES ('#{question}', '#{answer1}', '#{answer2}', '#{answer3}', '#{answer4}', #{correct_answer}, #{i + 1})"
  end
end


