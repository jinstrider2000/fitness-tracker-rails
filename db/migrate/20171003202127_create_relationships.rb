class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.belongs_to :follower
      t.belongs_to :followee
      t.boolean :blocked, null: false, default: false

      t.timestamps
    end
  end
end
