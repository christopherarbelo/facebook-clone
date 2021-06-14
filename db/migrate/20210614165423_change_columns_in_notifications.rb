class ChangeColumnsInNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :type, :kind
    rename_column :notifications, :type_id, :kind_id
  end
end
