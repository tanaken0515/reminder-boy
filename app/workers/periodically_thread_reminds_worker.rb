class PeriodicallyThreadRemindsWorker
  include Sidekiq::Worker

  def perform
    # 定期実行が数秒〜数分遅れる可能性はある。のでfrom,toは要検討。
    interval = 5 * 60 # 5分間隔で実行する予定
    to = Time.zone.now
    from = to - (interval - 1).seconds  # 09:10:00 に実行された場合、この値は 09:05:01

    thread_reminders_by_time_zone = ThreadReminder.scheduled_between(from, to)
                                      .includes(reminder: :user)
                                      .group_by{|thread_reminder| thread_reminder.reminder.user.time_zone}

    thread_reminders_by_time_zone.each do |time_zone, thread_reminder|
      Time.use_zone(time_zone) do
        thread_reminder_ids = ThreadReminder.where(id: thread_reminder.pluck(:id)).active_on_date(Time.zone.today).pluck(:id)
        thread_reminder_ids.each do |thread_reminder_id|
          ThreadRemindWorker.perform_async(thread_reminder_id)
        end
      end
    end
  end
end
