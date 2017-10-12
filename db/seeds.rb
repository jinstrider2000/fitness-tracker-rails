# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(name: "Generic Guy", email: "genericguy@email.com", daily_calorie_intake_goal: 1000, password: "password", quote: "I love fitness!")
user2 = User.create(name: "Generic Gal", email: "genericgal@email.com", daily_calorie_intake_goal: 800, password: "password", quote: "Gonna try my best!")
relationship = Relationship.create(follower: user, followee: user2)
relationship2 = Relationship.create(follower: user2, followee: user)
achievement1 = Achievement.create(user: user, activity_attributes: {name: "Running", calories_burned: 500, comment: "Wow, that was a great workout!"})
achievement2 = Achievement.create(user: user2, activity_attributes: {name: "Asparagus", calories: 15, comment: "Tasty, well seasoned!"})