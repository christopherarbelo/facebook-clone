class AddIndexToLikes < ActiveRecord::Migration[6.1]
  def change
    add_index :likes, [:user_id, :likable_id, :likable_type], unique: true
  end
end
