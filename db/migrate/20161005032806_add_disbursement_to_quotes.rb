class AddDisbursementToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :disbursement, :decimal
  end
end
