class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.belongs_to :follower
      t.belongs_to :followee
      t.boolean :blocked, default: false
      t.boolean :following_each_other, default: false

      t.timestamps
    end
  end
end
