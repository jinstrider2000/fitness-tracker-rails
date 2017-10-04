class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.belongs_to :follower, foreign_key: true
      t.belongs_to :followee, foreign_key: true

      t.timestamps
    end
  end
end
