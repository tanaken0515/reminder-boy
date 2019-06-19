class Reminder < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :remind_logs

  validates :slack_channel_id, presence: true
  validates :message, presence: true
  validates :hour,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 23}
  validates :minute,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 59}
  enumerize :status, in: { activated: 0, deactivated: 1, archived: 2 },
            default: :activated, predicates: true, scope: true

  after_validation :set_scheduled_time

  scope :from_latest, -> {order(created_at: :desc)}
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
    params = {
      channel: slack_channel_id,
      text: message,
      as_user: false,
      icon_emoji: ":#{icon_emoji}:",
      username: icon_name,
      link_names: true,
    }
    begin
      user.slack_client.chat_postMessage(params)
    rescue => e
      Rails.logger.error e.message
      {ok: false, error: e.message}
    end
  end

  def remind!
    response = post
    default_emoji_url = 'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/twitter/185/dog-face_1f436.png'
    params = {
      slack_channel_id: slack_channel_id,
      message: message,
      icon_emoji: icon_emoji,
      icon_name: icon_name,
      slack_message_ts: response.ts,
      emoji_url: response.dig(:message, :icons, :image_64) || default_emoji_url
    }
    remind_logs.create!(params)
  end

  def set_scheduled_time
    self.scheduled_time = format("%02d:%02d", hour, minute)
  end
end
