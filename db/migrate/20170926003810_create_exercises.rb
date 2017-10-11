class CreateExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :exercises do |t|
      t.string :name, null: false
      t.integer :calories_burned, null: false
      t.string :comment, null: false, default: ""

      t.timestamps
    end
  end
end
