class RemoveCommentFromExercisesAndFoods < ActiveRecord::Migration[5.1]
  def change
    remove_column :comment, :foods, :string
    remove_column :comment, :exercises, :string
  end
end
