class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks do |t|
      t.belongs_to :user, null: false
      t.belongs_to :blocked_user, null: false

      t.timestamps
    end
  end
end
