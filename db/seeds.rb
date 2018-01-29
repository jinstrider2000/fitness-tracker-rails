# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
bono_pic_path = File.join(Dir.pwd, "db", "seed_assets", "images", "bono_pic.png")
valli_pic_path = File.join(Dir.pwd, "db", "seed_assets", "images", "frankie_valli_pic.jpg")
efrain_pic_path = File.join(Dir.pwd, "db", "seed_assets", "images", "efrain_pic.jpg")

bono_pic_file = ActionDispatch::Http::UploadedFile.new(tempfile: File.new(bono_pic_path), type: 'image/png')
valli_pic_file = ActionDispatch::Http::UploadedFile.new(tempfile: File.new(valli_pic_path), type: 'image/jpeg')
efrain_pic_file = ActionDispatch::Http::UploadedFile.new(tempfile: File.new(efrain_pic_path), type: 'image/jpeg')

efrain = User.create(name: "Efrain Perez Jr", email: "efrainperezjr@email.com", daily_calorie_intake_goal: 2500, password: "password", quote: "Hi, I'm Efrain. You don't know me, but think of me as Fitness Tracker's \"Tom\". Thanks for demoing my app!", profile_pic: efrain_pic_file)
frankie_valli = User.create(name: "Frankie Valli", email: "f_valli@email.com", daily_calorie_intake_goal: 1800, password: "password", quote: "Who loves you pretty baby?!?", profile_pic: valli_pic_file)
bono = User.create(name: "Bono Vox", email: "bono@email.com", daily_calorie_intake_goal: 2000, password: "password", quote: "I love fitness and saving the planet from all things sad and awful...and I love U2!", profile_pic: bono_pic_file)

efrain.follow(frankie_valli)
efrain.follow(bono)
frankie_valli.follow(bono)
bono.follow(frankie_valli)

frankie_valli.achievements.create(completed_on: Date.today, comment: "Wow, that was a great workout!", activity_attributes: {"name" => "Running", "calories_burned" => 500})
frankie_valli.achievements.create(completed_on: Date.today, comment: "Gotta change my running shoes...", activity_attributes: {"name" => "Jogging", "calories_burned" => 200})
bono.achievements.create(completed_on: Date.today, comment: "My biceps are getting bigger!", activity_attributes: {"name" => "Weights", "calories_burned" => 350})
frankie_valli.achievements.create(completed_on: Date.today - 1, comment: "Couldn't do that long, my knees hurt.", activity_attributes: {"name" => "Stair Climber", "calories_burned" => 50})
bono.achievements.create(completed_on: Date.today - 1, comment: "Oh, my heart!", activity_attributes: {"name" => "Cardio", "calories_burned" => 7000})
bono.achievements.create(completed_on: Date.today - 2, comment: "Low impact, but pretty good.", activity_attributes: {"name" => "Treadmill", "calories_burned" => 200})
frankie_valli.achievements.create(completed_on: Date.today - 2, comment: "Mindhunter is awesome! (I know this isn't technically exercise)", activity_attributes: {"name" => "Watching Netflix", "calories_burned" => 20})
frankie_valli.achievements.create(completed_on: Date.today - 3, comment: "Watched Stranger Things 2 (Sitting through that was so excruciating, it counts as exercise!)", activity_attributes: {"name" => "Watching Netflix", "calories_burned" => 50})

frankie_valli.achievements.create(completed_on: Date.today, comment: "Tasty, well seasoned!", activity_attributes: {"name" => "Asparagus", "calories" => 15})
frankie_valli.achievements.create(completed_on: Date.today, comment: "Mmm, love the crispy skin!", activity_attributes: {"name" => "Salmon", "calories" => 200})
bono.achievements.create(completed_on: Date.today, comment: "Love that Thousand Island!", activity_attributes: {"name" => "Garden Salad w/dressing", "calories" => 50})
frankie_valli.achievements.create(completed_on: Date.today - 1, comment: "A little bland, but ok.", activity_attributes: {"name" => "Turkey Burger", "calories" => 300})
bono.achievements.create(completed_on: Date.today - 1, comment: "Did I overdo it? All well, there's always tomorrow", activity_attributes: {"name" => "BBQ Wings (20 pieces)", "calories" => 2000})
bono.achievements.create(completed_on: Date.today - 2, comment: "I see a trend starting... :)", activity_attributes: {"name" => "Buffalo Wings (30 pieces)", "calories" => 3000})
frankie_valli.achievements.create(completed_on: Date.today - 2, comment: "Yuk! Why did I eat this?!?!?", activity_attributes: {"name" => "Liverwurst", "calories" => 200})
frankie_valli.achievements.create(completed_on: Date.today - 3, comment: "Arbys! We have the MEATS!!", activity_attributes: {"name" => "Roast Beef Sandwich (Arby's)", "calories" => 300})

efrain.achievements.create(completed_on: Date.today - 3, comment: "Yes, I'm a sedantary person. Please don't judge me. I intend this to be a judgment free zone...like Planet Fitness.", activity_attributes: {"name" => "Sitting down, programming this website (4 months)", "calories_burned" => 50})