class AddBarsToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :bars, :text, array: true, default: []
  end
end
