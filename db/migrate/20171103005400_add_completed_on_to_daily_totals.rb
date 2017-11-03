class AddCompletedOnToDailyTotals < ActiveRecord::Migration[5.1]
  def change
    add_column :daily_totals, :completed_on, :datetime
  end
end
