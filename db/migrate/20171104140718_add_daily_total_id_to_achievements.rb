class AddDailyTotalIdToAchievements < ActiveRecord::Migration[5.1]
  def change
    add_column :achievements, :daily_total_id, :integer
  end
end
