class AddLocaleToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :locale, :string
  end
end
