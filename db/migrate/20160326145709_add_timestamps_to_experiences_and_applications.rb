class AddTimestampsToExperiencesAndApplications < ActiveRecord::Migration
  def change
    add_column :experiences, :created_at, :datetime
    add_column :experiences, :updated_at, :datetime
    add_column :applications, :created_at, :datetime
    add_column :applications, :updated_at, :datetime
  end
end
