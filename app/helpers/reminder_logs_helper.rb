module ReminderLogsHelper
  def slack_channel_name(reminder_log)
    slack_channel = current_user.slack_channel_list[reminder_log.slack_channel_id]
    slack_channel ? slack_channel.name : ''
  end
end
