class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.belongs_to :follower, foreign_key: true
      t.belongs_to :followee, foreign_key: true
      t.boolean :blocked, null: false, default: false

      t.timestamps
    end
  end
end
