class PeriodicallyRemindsWorker
  include Sidekiq::Worker

  def perform
    # 定期実行が数秒〜数分遅れる可能性はある。のでfrom,toは要検討。
    interval = 5 * 60 # 5分間隔で実行する予定
    to = Time.zone.now
    from = to - (interval - 1).seconds  # 09:10:00 に実行された場合、この値は 09:05:01

    reminder_ids = Reminder.active_on_date(Time.zone.today).scheduled_between(from, to).pluck(:id)
    reminder_ids.each do |reminder_id|
      RemindWorker.perform_async(reminder_id)
    end
  end
end
