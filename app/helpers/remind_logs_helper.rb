module RemindLogsHelper
  def slack_channel_name(remind_log)
    slack_channel = current_user.slack_channel_list[remind_log.slack_channel_id]
    slack_channel ? slack_channel.name : ''
  end

  def slack_emoji_url(remind_log)
    default_emoji_url = 'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/twitter/185/dog-face_1f436.png'
    current_user.slack_emoji_list[remind_log.icon_emoji] || default_emoji_url
  end
end
