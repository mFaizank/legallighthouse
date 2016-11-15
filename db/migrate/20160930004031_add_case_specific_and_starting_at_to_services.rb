class AddCaseSpecificAndStartingAtToServices < ActiveRecord::Migration
  def change
    add_column :services, :case_specific, :boolean, default: false
    add_column :services, :starting_at, :boolean, default: false
  end
end
