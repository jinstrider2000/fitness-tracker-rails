class RemoveCommentFromExercisesAndFoods < ActiveRecord::Migration[5.1]
  def change
    remove_column :foods, :comment, :string
    remove_column :exercises, :comment, :string
  end
end
