class CreatePaymentRequests < ActiveRecord::Migration
  def change
    create_table :payment_requests do |t|
      t.decimal :amount
      t.string :status
      t.boolean :disbursement, default: false
      t.string :description
      t.belongs_to :quote, index: true, foreign_key: true
      t.timestamps
    end
  end
end
