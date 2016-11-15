class CreateLawyerLeads < ActiveRecord::Migration
  def change
    create_table :lawyer_leads do |t|
      t.string :email
      t.text :practices, array: true, default: []
      t.timestamp :created_at, null: false
    end
  end
end
