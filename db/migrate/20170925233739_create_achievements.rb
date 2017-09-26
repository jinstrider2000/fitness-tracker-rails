class CreateAchievements < ActiveRecord::Migration[5.1]
  def change
    create_table :achievements do |t|
      t.belongs_to :activity, polymorphic: true
      t.belongs_to :user

      t.timestamps
    end
  end
end
