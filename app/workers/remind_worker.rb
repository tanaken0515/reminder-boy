class RemindWorker
  include Sidekiq::Worker

  def perform(reminder_id)
    reminder = Reminder.find(reminder_id)
    reminder.remind!
  end
end
