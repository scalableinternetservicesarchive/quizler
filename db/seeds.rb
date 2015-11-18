# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


heather = User.create!(username: 'Heather', email: 'heather@whatever.com', password: 'awesomepassword')

Quiz.create!(title: 'Soccer Quiz', description: 'A quiz about soccer', author_id: heather.id)
Quiz.create!(title: 'Beer Quiz', description: 'A quiz about beer', author_id: heather.id)

Question.create!(question: 'Where is David Beckham from?', answer1: 'Spain', answer2: 'England', answer3: 'Norway', answer4: 'France', quiz_id: 1, correct_answer: 2)
Question.create!(question: 'In which league are Arsenal playing?', answer1: 'Premier League', answer2: 'La Liga', quiz_id: 1, correct_answer: 1)
Question.create!(question: 'Who won the World Cup in 2002?', answer1: 'France', answer2: 'Germany', answer3: 'Brazil', quiz_id: 1, correct_answer: 3)
Question.create!(question: 'What do the players kick?', answer1: 'Girls', answer2: 'Boys', answer3: 'Balls', answer4: 'Nuts', quiz_id: 1, correct_answer: 3)

Question.create!(question: 'Where can you buy a beer?', answer1: 'At the laundry', answer2: 'At a bar', answer3: 'In the kindergarden', quiz_id: 2, correct_answer: 2)
Question.create!(question: 'Which is NOT a beer?', answer1: 'Duff', answer2: 'Corona', answer3: 'Quizler', answer4: 'Heineken', quiz_id: 2, correct_answer: 3)


number_quizzes = 10000
number_questions = 8

number_users = 10000

max_received_friend_requests_per_user = 2
max_friends_per_user = 40

users_per_commit = 250
friendships_per_commit = 250

number_friendships_per_user = max_received_friend_requests_per_user + max_friends_per_user

insert_users = []
insert_friendships = []

if User.count < 10 then

  User.transaction do
    (2..number_users).each do |i|
      username = Faker::Internet.user_name + '_' + i.to_s
      domain = Faker::Internet.domain_name
      email = "#{username}@#{domain}"
      created_at = Time.now.strftime('%Y-%m-%d 00:00:00')
      encrypted_password ='$2a$10$aNyB6msOBG5yluXKYsXD9ekGYcFxxh0mQbHv4r6L2T7PowE4xcbWS' # password: awesomepassword

      insert_users << "('#{username}', '#{email}', '#{encrypted_password}', 0, '#{created_at}', '#{created_at}')"

      if i > users_per_commit
        sql = "INSERT INTO users (`username`, `email`, `encrypted_password`, `sign_in_count`, `created_at`, `updated_at`) VALUES #{insert_users.join(', ')}"
        User.connection.execute sql
        insert_users = []
      end
    end
  end


  def direction_of_friendship(user_id, friend_id, friendship_id, accepted_at)
    if accepted_at.nil?
      # if friendship not yet accepted, we consider the direction of friendship to be a request for user_id
      [friend_id, user_id]
    else
      # Every other friendships we switch the direction of the friendships (this decision si totally random)
      friendship_id % 2 == 0 ? [user_id, friend_id] : [friend_id, user_id]
    end
  end

  Friendship.transaction do
    friendship_id = 1

    (1..number_users).each do |user_1|
      remaining_friends_for_user_1 = number_friendships_per_user - ((user_1 - 1) % (number_friendships_per_user+1))
      first_included_friend_id = user_1 + 1
      last_included_friend_id = user_1 + remaining_friends_for_user_1

      (first_included_friend_id..last_included_friend_id).each do |i|
        user_2 = i > number_users ? ((i % number_users) + 1) : i

        # First remaining friendships for a user_1 are friend requests
        if i < first_included_friend_id + max_received_friend_requests_per_user
          created_at = Time.now.strftime('%Y-%m-%d 00:00:00')
          accepted_at = nil
        else
          created_at = Faker::Date.between('01/01/2013', Date.today.to_s).strftime('%Y-%m-%d 00:00:00')
          accepted_at = created_at
        end

        user_id, friend_id = direction_of_friendship(user_1, user_2, friendship_id, accepted_at)
        accepted_at_str = accepted_at.nil? ? 'NULL' : "'#{created_at}'"

        insert_friendships << "('#{user_id}', '#{friend_id}', #{accepted_at_str}, '#{created_at}', '#{created_at}')"
        friendship_id += 1

        if insert_friendships.count > friendships_per_commit
          sql = "INSERT INTO friendships (`user_id`, `friend_id`, `accepted_at`, `created_at`, `updated_at`) VALUES #{insert_friendships.join(', ')}"
          Friendship.connection.execute sql
          insert_friendships = []
        end
      end
    end
  end


  Quiz.transaction do
    number_quizzes.times do |i|
      sentences = Faker::Lorem.sentences(2)
      title = sentences[0]
      description = sentences[1]
      author_id = Random.rand(1..number_users)
      Quiz.connection.execute "INSERT INTO quizzes (title, description, author_id) VALUES ('#{title}', '#{description}', '#{author_id}')"

      Question.transaction do
        number_questions.times do
          answers = Faker::Lorem.words(8)

          question = answers[4] + " " + answers[5]  + " " + answers[6] + " " + answers[7] + "?"
          answer1 = answers[0]
          answer2 = answers[1]
          answer3 = answers[2]
          answer4 = answers[3]
          correct_answer = Random.rand(1..4)

          Question.connection.execute "INSERT INTO questions (question, answer1, answer2, answer3, answer4, correct_answer, quiz_id) VALUES ('#{question}', '#{answer1}', '#{answer2}', '#{answer3}', '#{answer4}', #{correct_answer}, #{i + 1})"
        end
      end
    end
  end
end







# def find_and_set_random_friend_in_hash(user_1, friends_hash, number_users)
#   friends_hash[user_1] = {} if friends_hash[user_1].nil?
#
#   while true
#     user_2 = 1 + Random.rand(number_users)
#
#     friends_hash[user_2] = {} if friends_hash[user_2].nil?
#
#     if friends_hash[user_2][user_1].nil?
#       friends_hash[user_1][user_2] = true
#       friends_hash[user_2][user_1] = true
#       return user_2
#     end
#   end
# end
#
# def remember_friendship(user_1, user_2, friends_hash)
#   friends_hash[user_1] = {} if friends_hash[user_1].empty?
#   friends_hash[user_2] = {} if friends_hash[user_2].empty?
#
#   friends_hash[user_1][user_2] = true
#   friends_hash[user_2][user_1] = true
# end
#
# def random_acceptation_of_friendship(current_user_id, first_user_id, last_user_id_without_modulo)
#   is_accepted = Random.rand(2)
#   return is_accepted == 1 ? Faker::Date.between('01/01/2013', Date.today.to_s) : nil
# end
#
#
# friends_hash = {}
#
# ActiveRecord::Base.transaction do
#   number_users.times do |i|
#     max_number_friends_per_user.times do
#       user_1 = i+1
#       user_2 = find_and_set_random_friend_in_hash(user_1, friends_hash, number_users)
#       p user_1
#
#       direction_friendship = Random.rand(2)
#       accepted_at = random_acceptation_of_friendship
#
#       arguments = {accepted_at: accepted_at}
#       if direction_friendship == 1
#         arguments.merge!({user_id: user_1, friend_id: user_2})
#       else
#         arguments.merge!({user_id: user_2, friend_id: user_1})
#       end
#
#       Friendship.create(arguments)
#     end
#   end
# end
