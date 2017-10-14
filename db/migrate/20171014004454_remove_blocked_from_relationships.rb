class RemoveBlockedFromRelationships < ActiveRecord::Migration[5.1]
  def change
    remove_column :relationships, :blocked, :boolean
  end
end
