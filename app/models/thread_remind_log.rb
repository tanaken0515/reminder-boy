class ThreadRemindLog < ApplicationRecord
  belongs_to :thread_reminder

  validates :slack_channel_id, presence: true
  validates :message, presence: true
  validates :slack_message_ts, presence: true

  before_create :set_slack_permalink

  scope :from_latest, -> () {order(created_at: :desc)}

  def set_slack_permalink
    slack_client = thread_reminder.reminder.user.slack_client

    self.slack_permalink = begin
      response = slack_client.chat_getPermalink(channel: slack_channel_id, message_ts: slack_message_ts)
      response.permalink
    rescue => e
      Rails.logger.error e.message
      nil
    end
  end
end
