class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.belongs_to :lawyer, index: true, foreign_key: true
    end
  end
end
