class AddFixedFeesAndUnbundlingToLawyers < ActiveRecord::Migration
  def change
    add_column :lawyers, :fixed_fees, :boolean, default: false
    add_column :lawyers, :unbundling, :boolean, default: false
  end
end
