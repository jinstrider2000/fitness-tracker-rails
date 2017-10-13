class CreateMutes < ActiveRecord::Migration[5.1]
  def change
    create_table :mutes do |t|
      t.belongs_to :user, null: false
      t.belongs_to :muted_user, null: false

      t.timestamps
    end
  end
end
