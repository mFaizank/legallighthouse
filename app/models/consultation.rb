class Consultation < ActiveRecord::Base
  enum status: %i(pending proposed confirmed declined cancelled undecided)

  belongs_to :lawyer
  belongs_to :user
  has_many :proposed_times, dependent: :destroy

  accepts_nested_attributes_for :proposed_times

  validates :description, :lawyer, :user, presence: true
  validates_associated :proposed_times

  def build_proposed_times
    3.times { proposed_times.build }
  end

  def set_default_time
    self.time = proposed_times.first && proposed_times.first.time
  end

  def client_name
    user.public_name
  end

  def lawyer_name
    lawyer.public_name
  end

  def type
    user.business ? 'Business' : 'Individual'
  end

  def human_time
    time && time.to_formatted_s(:long)
  end

  def time_options
    proposed_times.map {|p| [p.time, p.human_time] } <<
      ['none', 'None are convenient']
  end
end
