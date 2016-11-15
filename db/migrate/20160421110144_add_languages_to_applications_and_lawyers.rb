class AddLanguagesToApplicationsAndLawyers < ActiveRecord::Migration
  def change
    add_column :applications, :languages, :text, array: true, default: []
    add_column :lawyers, :languages, :text, array: true, default: []
  end
end
