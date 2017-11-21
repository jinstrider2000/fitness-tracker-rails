# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user1 = User.create(name: "Generic Guy", email: "genericguy@email.com", daily_calorie_intake_goal: 1000, password: "password", quote: "I love fitness!")
user2 = User.create(name: "Generic Gal", email: "genericgal@email.com", daily_calorie_intake_goal: 800, password: "password", quote: "Gonna try my best!")

user1.follow(user2)
user2.follow(user1)

user1.achievements.create(completed_on: Date.today, comment: "Wow, that was a great workout!", activity_attributes: {name: "Running", calories_burned: 500})
user1.achievements.create(completed_on: Date.today, comment: "Gotta change my running shoes...", activity_attributes: {name: "Jogging", calories_burned: 200})
user2.achievements.create(completed_on: Date.today, comment: "My biceps are getting bigger!", activity_attributes: {name: "Weights", calories_burned: 350})
user1.achievements.create(completed_on: Date.today - 1, comment: "Couldn't do that long, my knees hurt.", activity_attributes: {name: "Stair Climber", calories_burned: 50})
user2.achievements.create(completed_on: Date.today - 1, comment: "Oh, my heart!", activity_attributes: {name: "Cardio", calories_burned: 7000})
user2.achievements.create(completed_on: Date.today - 2, comment: "Low impact, but pretty good.", activity_attributes: {name: "Treadmill", calories_burned: 200})
user1.achievements.create(completed_on: Date.today - 2, comment: "Mindhunter is awesome! (I know this isn't technically exercise)", activity_attributes: {name: "Watching Netflix", calories_burned: 20})
user1.achievements.create(completed_on: Date.today - 3, comment: "Watched Stranger Things 2 (Sitting through that was so excruciating, it counts as exercise!)", activity_attributes: {name: "Watching Netflix", calories_burned: 50})

user1.achievements.create(completed_on: Date.today, comment: "Tasty, well seasoned!", activity_attributes: {name: "Asparagus", calories: 15})
user1.achievements.create(completed_on: Date.today, comment: "Mmm, love the crispy skin!", activity_attributes: {name: "Salmon", calories: 200})
user2.achievements.create(completed_on: Date.today, comment: "Love that Thousand Island!", activity_attributes: {name: "Garden Salad w/dressing", calories: 50})
user1.achievements.create(completed_on: Date.today - 1, comment: "A little bland, but ok.", activity_attributes: {name: "Turkey Burger", calories: 300})
user2.achievements.create(completed_on: Date.today - 1, comment: "Did I overdo it? All well, there's always tomorrow", activity_attributes: {name: "BBQ Wings (20 pieces)", calories: 2000})
user2.achievements.create(completed_on: Date.today - 2, comment: "I see a trend starting... :)", activity_attributes: {name: "Buffalo Wings (30 pieces)", calories: 3000})
user1.achievements.create(completed_on: Date.today - 2, comment: "Yuk! Why did I eat this?!?!?", activity_attributes: {name: "Liverwurst", calories: 200})
user1.achievements.create(completed_on: Date.today - 3, comment: "Arbys! We have the MEATS!!", activity_attributes: {name: "Roast Beef Sandwich (Arby's)", calories: 300})