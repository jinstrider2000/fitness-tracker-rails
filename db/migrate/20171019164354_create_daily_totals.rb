class CreateDailyTotals < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_totals do |t|
      t.integer :total_calories_in, null: false, default: 0
      t.integer :total_calories_out, null: false, default: 0
      t.integer :net_calories, null: false, default: 0
      t.belongs_to :user

      t.timestamps
    end
  end
end
