class ChangeNotifications < ActiveRecord::Migration[6.1]
  def change
    remove_column :notifications, :message
    add_reference :notifications, :action_user, null: false, foreign_key: { to_table: :users }
    add_column :notifications, :type, :integer, null: false
    add_column :notifications, :type_id, :bigint
    add_index :notifications, [:user_id, :action_user_id, :type, :type_id], unique: true, name: 'index_notifications_on_user_id__action_user_id___type___type_id'
  end
end
