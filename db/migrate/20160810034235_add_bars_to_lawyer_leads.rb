class AddBarsToLawyerLeads < ActiveRecord::Migration
  def change
    add_column :lawyer_leads, :first_name, :string
    add_column :lawyer_leads, :last_name, :string
    add_column :lawyer_leads, :bars, :text, array: true, default: []
  end
end
