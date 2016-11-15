class AddSpecializationToApplicationsAndLawyers < ActiveRecord::Migration
  def change
    add_column :applications, :specializations, :text, array: true, default: []
    add_column :lawyers, :specializations, :text, array: true, default: []
  end
end
