class ThreadReminder < ApplicationRecord
  extend Enumerize

  belongs_to :reminder
  has_many :thread_remind_logs

  validates :message, presence: true
  enumerize :status, in: { activated: 0, deactivated: 1, archived: 2 },
            default: :activated, predicates: true, scope: true

  # custom validations
  validate :validate_scheduled_time_is_included_in_scheduled_time_list

  scope :holiday_included, -> {where(holiday_included: true)}
  scope :enabled_on_day_of_week, ->(wday) {
    case wday
    when 0
      where(sunday_enabled: true)
    when 1
      where(monday_enabled: true)
    when 2
      where(tuesday_enabled: true)
    when 3
      where(wednesday_enabled: true)
    when 4
      where(thursday_enabled: true)
    when 5
      where(friday_enabled: true)
    when 6
      where(saturday_enabled: true)
    else
      none
    end
  }
  scope :active_on_date, ->(date) {
    scope = with_status(:activated).enabled_on_day_of_week(date.wday)
    HolidayJp.holiday?(date) ? scope.holiday_included : scope
  }
  scope :scheduled_between, ->(from, to) {
    return none if from > to

    from_time = from.strftime("%H:%M:%S")
    to_time = to.strftime("%H:%M:%S")

    if from_time > to_time
      where(scheduled_time: from_time..'23:59:59').or(where(scheduled_time: '00:00:00'..to_time))
    else
      where(scheduled_time: from_time..to_time)
    end
  }

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

    remind_log = reminder.remind_logs.from_latest.first
    params = {
      channel: remind_log.slack_channel_id,
      text: message,
      as_user: false,
      icon_emoji: ":#{icon_emoji}:",
      username: icon_name,
      thread_ts: remind_log.slack_message_ts,
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

  def remind!
    response = post
    return unless response.ok

    default_emoji_url = 'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/twitter/185/dog-face_1f436.png'
    params = {
      slack_channel_id: response.channel,
      message: message,
      icon_emoji: icon_emoji,
      icon_name: icon_name,
      slack_message_ts: response.ts,
      emoji_url: response.dig(:message, :icons, :image_64) || default_emoji_url
    }
    thread_remind_logs.create!(params)
  end

  private

  def validate_scheduled_time_is_included_in_scheduled_time_list
    unless ThreadReminder.scheduled_time_list.include?(scheduled_time.try(:strftime, '%H:%M'))
      errors.add(:scheduled_time, 'is not included in scheduled time list')
    end
  end
end
