class AddProfileToLawyer < ActiveRecord::Migration
  def change
    add_column :lawyers, :profile_image, :string
    add_column :lawyers, :designation, :string
    add_column :lawyers, :location, :string
    add_column :lawyers, :years_of_experience, :integer
    add_column :lawyers, :bio, :text
    add_column :lawyers, :consultation_hourly_rate, :decimal
  end
end
