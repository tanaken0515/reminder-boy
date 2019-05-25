class Reminder < ApplicationRecord
  belongs_to :user

  validates :slack_channel_id, presence: true
  validates :message, presence: true
  validates :hour,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23}
  validates :minute,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59}
  validates :status, presence: true

  before_validation :set_default

  private

  def set_default
    self.status ||= 0 #todo: Enumerizeで良い感じにする
  end
end
