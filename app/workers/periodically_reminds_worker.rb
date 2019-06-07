class PeriodicallyRemindsWorker
  include Sidekiq::Worker

  def perform
    # todo: 曜日と時刻でreminderのidを取得する
    reminder_ids = []

    reminder_ids.echo do |reminder_id|
      RemindWorker.perform_async(reminder_id)
    end
  end
end
