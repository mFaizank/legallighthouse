class AddPublicIdToLawyers < ActiveRecord::Migration
  def change
    add_column :lawyers, :public_id, :string
    add_index :lawyers, :public_id, unique: true
  end
end
