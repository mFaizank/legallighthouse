class ProposedTime < ActiveRecord::Base
  belongs_to :consultation

  validates :time, presence: true
  validates :time, inclusion: {
    in: Time.now..(Time.now + 1.month),
    message: 'must be within the next month'
  }
  validates :consultation, presence: true

  def human_time
    time && time.to_formatted_s(:long)
  end
end
