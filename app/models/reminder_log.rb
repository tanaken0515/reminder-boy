class ReminderLog < ApplicationRecord
  belongs_to :reminder

  validates :slack_channel_id, presence: true
  validates :message, presence: true
  validates :slack_message_ts, presence: true
end
