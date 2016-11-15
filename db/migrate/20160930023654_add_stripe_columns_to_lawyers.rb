class AddStripeColumnsToLawyers < ActiveRecord::Migration
  def change
    add_column :lawyers, :stripe_token, :string
    add_column :lawyers, :stripe_account_id, :string
  end
end
