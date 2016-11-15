class AddBarNumberAndCvToLawyers < ActiveRecord::Migration
  def change
    add_column :lawyers, :bar_number, :string
    add_column :lawyers, :cv, :string
  end
end
