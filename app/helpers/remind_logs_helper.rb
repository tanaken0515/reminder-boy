module RemindLogsHelper
  def slack_channel_name(remind_log)
    slack_channel = current_user.slack_channel_list[remind_log.slack_channel_id]
    slack_channel ? slack_channel.name : ''
  end

  def slack_emoji_url(remind_log)
    current_user.slack_emoji_list[remind_log.icon_emoji]
  end
end
