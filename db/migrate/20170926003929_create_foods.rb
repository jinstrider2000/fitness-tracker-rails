class CreateFoods < ActiveRecord::Migration[5.1]
  def change
    create_table :foods do |t|
      t.string :name, null: false
      t.integer :calories, null: false
      t.string :comment, null: false, default: ""

      t.timestamps
    end
  end
end
