class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.string :description
      t.decimal :fixed_fee
      t.boolean :unbundling, default: false
      t.string :specialization, null: false
      t.belongs_to :lawyer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
