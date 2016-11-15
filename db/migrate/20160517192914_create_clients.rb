class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :status, default: 0
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :lawyer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
