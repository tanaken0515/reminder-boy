class PeriodicallyRemindsWorker
  include Sidekiq::Worker

  def perform
    # 定期実行が数秒〜数分遅れる可能性はある。のでfrom,toは要検討。
    interval = 5 * 60 # 5分間隔で実行する予定
    to = Time.zone.now
    from = to - (interval - 1).seconds  # 09:10:00 に実行された場合、この値は 09:05:01

    reminders_by_time_zone = Reminder.scheduled_between(from, to)
                               .includes(:user).group_by{|reminder| reminder.user.time_zone}

    reminders_by_time_zone.each do |time_zone, reminders|
      Time.use_zone(time_zone) do
        reminder_ids = Reminder.where(id: reminders.pluck(:id)).active_on_date(Time.zone.today).pluck(:id)
        reminder_ids.each do |reminder_id|
          RemindWorker.perform_async(reminder_id)
        end
      end
    end
  end
end
