class PeriodicallyRemindsWorker
  include Sidekiq::Worker

  def perform
    reminder_scope = Reminder.active_on_date(Time.zone.today)
    # todo: 時刻でreminderのscopeを絞る

    reminder_ids = reminder_scope.pluck(:id)

    reminder_ids.each do |reminder_id|
      RemindWorker.perform_async(reminder_id)
    end
  end
end
