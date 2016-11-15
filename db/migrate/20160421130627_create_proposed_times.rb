class CreateProposedTimes < ActiveRecord::Migration
  def change
    create_table :proposed_times do |t|
      t.datetime :time
      t.belongs_to :consultation, index: true, foreign_key: true
    end
  end
end
