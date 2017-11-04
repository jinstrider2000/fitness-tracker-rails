class AddCompletedOnToAchievements < ActiveRecord::Migration[5.1]
  def change
    add_column :achievements, :completed_on, :date
  end
end
