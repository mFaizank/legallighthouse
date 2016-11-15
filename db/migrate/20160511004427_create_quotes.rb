class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :agreement
      t.decimal :fee
      t.decimal :advance
      t.datetime :completion_date
      t.belongs_to :lawyer, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
