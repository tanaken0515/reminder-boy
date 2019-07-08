class ThreadRemindWorker
  include Sidekiq::Worker

  def perform(thread_reminder_id)
    thread_reminder = ThreadReminder.includes(reminder: [:remind_logs, {user: :authentications}]).find(thread_reminder_id)
    thread_reminder.remind!
  end
end
