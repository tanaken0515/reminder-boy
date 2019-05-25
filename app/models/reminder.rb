class Reminder < ApplicationRecord
  belongs_to :user

  validates :slack_channel_id, presence: true
  validates :message, presence: true
  validates :hour, presence: true
  validates :minute, presence: true
  validates :status, presence: true
end
