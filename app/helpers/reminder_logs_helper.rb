module ReminderLogsHelper
  def slack_channel_name(remind_log)
    slack_channel = current_user.slack_channel_list[remind_log.slack_channel_id]
    slack_channel ? slack_channel.name : ''
  end
end
