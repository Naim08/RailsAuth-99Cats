class AddColumnInCatsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :cats, :owner_id, :bigint, null: false
    add_index :cats, :owner_id, unique: true
    add_foreign_key :cats, :users, column: :owner_id
  end
end
