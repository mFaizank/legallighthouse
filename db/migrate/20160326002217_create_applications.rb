class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :first_name
      t.string :last_name
      t.string :bar_number
      t.integer :year_of_call
      t.string :phone_number
      t.string :email
      t.string :cv
      t.hstore :data
      t.timestamp :approved_at
      t.timestamp :rejected_at
    end

    add_index :applications, :data, using: :gin
  end
end
