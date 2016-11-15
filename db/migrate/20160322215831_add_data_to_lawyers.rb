class AddDataToLawyers < ActiveRecord::Migration
  def change
    enable_extension 'hstore'
    add_column :lawyers, :data, :hstore
    add_index :lawyers, :data, using: :gin
  end
end
