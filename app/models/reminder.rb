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

  private

  def set_default
    self.status ||= 0 #todo: Enumerizeで良い感じにする
  end
end
