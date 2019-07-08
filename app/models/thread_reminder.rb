class ThreadReminder < ApplicationRecord
  extend Enumerize

  belongs_to :reminder

  validates :message, presence: true
  enumerize :status, in: { activated: 0, deactivated: 1, archived: 2 },
            default: :activated, predicates: true, scope: true

  # custom validations
  validate :validate_scheduled_time_is_included_in_scheduled_time_list

  def self.scheduled_time_list
    hour_list = (0..23).to_a
    minute_list = (0..59).step(5)

    scheduled_time_list = []
    hour_list.each do |hour|
      minute_list.each do |minute|
        scheduled_time_list << format('%02d:%02d', hour, minute)
      end
    end

    scheduled_time_list.map(&:freeze).freeze
  end

  def enabled_day_of_weeks
    day_of_weeks = %i(monday tuesday wednesday thursday friday saturday sunday)
    @enabled_day_of_week_list ||= day_of_weeks.select {|day_of_week| self.send("#{day_of_week}_enabled?")}
  end

  def everyday?
    enabled_day_of_weeks.size == 7
  end

  def weekday?
    # 平日の定義はuserごとに違うはず -> 要望が来たら対応する
    enabled_day_of_weeks == %i(monday tuesday wednesday thursday friday)
  end

  def holiday?
    # 休日の定義はuserごとに違うはず -> 要望が来たら対応する
    enabled_day_of_weeks == %i(saturday sunday)
  end

  def post
    if reminder.remind_logs.empty?
      return {ok: false, error: 'remind logs did not exist.'}
    end

    params = {
      channel: reminder.slack_channel_id,
      text: message,
      as_user: false,
      icon_emoji: ":#{icon_emoji}:",
      username: icon_name,
      thread_ts: reminder.remind_logs.last.slack_message_ts,
      reply_broadcast: also_send_to_channel,
      link_names: true,
    }
    begin
      reminder.user.slack_client.chat_postMessage(params)
    rescue => e
      Rails.logger.error e.message
      {ok: false, error: e.message}
    end
  end

  private

  def validate_scheduled_time_is_included_in_scheduled_time_list
    unless ThreadReminder.scheduled_time_list.include?(scheduled_time.try(:strftime, '%H:%M'))
      errors.add(:scheduled_time, 'is not included in scheduled time list')
    end
  end
end
