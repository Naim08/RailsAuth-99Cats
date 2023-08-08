class RemoveIndex < ActiveRecord::Migration[7.0]
  def change
    remove_index :cats, :owner_id
    add_index :cats, :owner_id
  end
end
