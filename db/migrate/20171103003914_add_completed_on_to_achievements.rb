class AddCompletedOnToAchievements < ActiveRecord::Migration[5.1]
  def change
    add_column :achievements, :completed_on, :datetime
  end
end
