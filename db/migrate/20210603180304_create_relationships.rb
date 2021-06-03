class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :status, null: false
      t.references :user_one, null: false, foreign_key: { to_table: :users }
      t.references :user_two, null: false, foreign_key: { to_table: :users }
      t.references :action_user, null: false, foreign_key: { to_table: :users }
      t.index([:user_one_id, :user_two_id], unique: true)
      t.timestamps
    end
  end
end
