class CreateAchievements < ActiveRecord::Migration[5.1]
  def change
    create_table :achievements do |t|
      t.references :activity, polymorphic: true, index: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
