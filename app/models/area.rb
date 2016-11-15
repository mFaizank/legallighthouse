class Area < ActiveRecord::Base
  belongs_to :lawyer, inverse_of: :areas

  validates :name, :lawyer, presence: true
  validates :name, uniqueness: { scope: :lawyer } 
end
