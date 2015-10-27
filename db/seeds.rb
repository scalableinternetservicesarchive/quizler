# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: 'Heather', email: 'heather@whatever.com', password: 'awesomepassword')
User.create(username: 'Jeff', email: 'jeff@whatever.com', password: 'awesomepassword')
User.create(username: 'Laura', email: 'laura@whatever.com', password: 'awesomepassword')
User.create(username: 'Steve', email: 'steve@whatever.com', password: 'awesomepassword')

Quiz.create(title: 'Soccer Quiz', description: 'A quiz about soccer', author: 'Heather')
Quiz.create(title: 'Beer Quiz', description: 'A quiz about beer', author: 'Jeff')

Question.create(question: 'Where is David Beckham from?', answer1: 'Spain', answer2: 'England', answer3: 'Norway', answer4: 'France', quiz_id: 1, correct_answer: 2)
Question.create(question: 'In which league are Arsenal playing?', answer1: 'Premier League', answer2: 'La Liga', quiz_id: 1, correct_answer: 1)
Question.create(question: 'Who won the World Cup in 2002?', answer1: 'France', answer2: 'Germany', answer3: 'Brazil', quiz_id: 1, correct_answer: 3)
Question.create(question: 'What do the players kick?', answer1: 'Girls', answer2: 'Boys', answer3: 'Balls', answer4: 'Nuts', quiz_id: 1, correct_answer: 3)

Question.create(question: 'Where can you buy a beer?', answer1: 'At the laundry', answer2: 'At a bar', answer3: 'In the kindergarden', quiz_id: 2, correct_answer: 2)
Question.create(question: 'Which is NOT a beer?', answer1: 'Duff', answer2: 'Corona', answer3: 'Quizler', answer4: 'Heineken', quiz_id: 2, correct_answer: 3)
