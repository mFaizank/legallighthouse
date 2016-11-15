class AddListedToLawyer < ActiveRecord::Migration
  def change
    add_column :lawyers, :listed, :boolean, default: false
  end
end
