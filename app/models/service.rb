class Service < ActiveRecord::Base
  belongs_to :lawyer, inverse_of: :services

  validates :name, :lawyer, presence: true
  validates :fixed_fee, presence: true, unless: :case_specific?
  validates :name, uniqueness: { scope: :lawyer }
  # validates :fixed_fee, numericality: { greater_than_or_equal_to: 1 }
  # validates :specialization, inclusion: { in: Application.specializations }

  before_save do
    if case_specific
      self.fixed_fee = nil
      self.starting_at = false if starting_at
    elsif starting_at
      self.case_specific = false if case_specific
    end
  end
end
