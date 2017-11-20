class AddCommentToAchievements < ActiveRecord::Migration[5.1]
  def change
    add_column :achievements, :comment, :string
  end
end
