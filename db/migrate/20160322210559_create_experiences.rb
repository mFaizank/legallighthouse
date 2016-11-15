class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :area
      t.integer :years
      t.belongs_to :lawyer, index: true, foreign_key: true
    end
  end
end
