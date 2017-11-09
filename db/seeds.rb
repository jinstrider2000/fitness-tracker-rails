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

user1.achievements.create(completed_on: Date.today, activity_attributes: {name: "Running", calories_burned: 500, comment: "Wow, that was a great workout!"})
user1.achievements.create(completed_on: Date.today, activity_attributes: {name: "Jogging", calories_burned: 200, comment: "Gotta change my running shoes..."})
user2.achievements.create(completed_on: Date.today, activity_attributes: {name: "Weights", calories_burned: 350, comment: "My biceps are getting bigger!"})
user1.achievements.create(completed_on: Date.today - 1, activity_attributes: {name: "Stair Climber", calories_burned: 50, comment: "Couldn't do that long, my knees hurt."})
user2.achievements.create(completed_on: Date.today - 1, activity_attributes: {name: "Cardio", calories_burned: 7000, comment: "Oh, my heart!"})
user2.achievements.create(completed_on: Date.today - 2, activity_attributes: {name: "Treadmill", calories_burned: 200, comment: "Low impact, but pretty good."})
user1.achievements.create(completed_on: Date.today - 2, activity_attributes: {name: "Watching Netflix", calories_burned: 20, comment: "Mindhunter is awesome! (I know this isn't technically exercise)"})
user1.achievements.create(completed_on: Date.today - 3, activity_attributes: {name: "Watching Netflix", calories_burned: 50, comment: "Watched Stranger Things 2 (Sitting through that was so excruciating, it counts as exercise!)"})

user1.achievements.create(completed_on: Date.today, activity_attributes: {name: "Asparagus", calories: 15, comment: "Tasty, well seasoned!"})
user1.achievements.create(completed_on: Date.today, activity_attributes: {name: "Salmon", calories: 200, comment: "Mmm, love the crispy skin!"})
user2.achievements.create(completed_on: Date.today, activity_attributes: {name: "Garden Salad w/dressing", calories: 50, comment: "Love that Thousand Island!"})
user1.achievements.create(completed_on: Date.today - 1, activity_attributes: {name: "Turkey Burger", calories: 300, comment: "A little bland, but ok."})
user2.achievements.create(completed_on: Date.today - 1, activity_attributes: {name: "BBQ Wings (20 pieces)", calories: 2000, comment: "Did I overdo it? All well, there's always tomorrow"})
user2.achievements.create(completed_on: Date.today - 2, activity_attributes: {name: "Buffalo Wings (30 pieces)", calories: 3000, comment: "I see a trend starting... :)"})
user1.achievements.create(completed_on: Date.today - 2, activity_attributes: {name: "Liverwurst", calories: 200, comment: "Yuk! Why did I eat this?!?!?"})
user1.achievements.create(completed_on: Date.today - 3, activity_attributes: {name: "Roast Beef Sandwich (Arby's)", calories: 300, comment: "Arbys! We have the MEATS!!"})