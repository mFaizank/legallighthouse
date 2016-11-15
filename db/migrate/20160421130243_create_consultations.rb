class CreateConsultations < ActiveRecord::Migration
  def change
    create_table :consultations do |t|
      t.datetime :time
      t.string :description
      t.integer :status, default: 0
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :lawyer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
