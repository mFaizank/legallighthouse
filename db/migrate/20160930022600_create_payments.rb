class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.string :payment_type
      t.belongs_to :quote, index: true, foreign_key: true
      t.belongs_to :lawyer, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
