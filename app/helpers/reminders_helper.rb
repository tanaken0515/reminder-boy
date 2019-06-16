module RemindersHelper
  def day_of_week(reminder)
    return '毎日' if reminder.everyday?
    return '平日' if reminder.weekday?
    return '休日' if reminder.holiday?

    dictionary = {
      monday: '月',
      tuesday: '火',
      wednesday: '水',
      thursday: '木',
      friday: '金',
      saturday: '土',
      sunday: '日'
    }
    reminder.enabled_day_of_weeks.map { |dow| dictionary[dow] }.join(',')
  end

  def slack_channel_name(reminder)
    slack_channel = current_user.slack_channel_list[reminder.slack_channel_id]
    slack_channel ? slack_channel.name : ''
  end

  def active_slack_channel_list
    current_user.slack_channel_list.map do |k, v|
      v.is_archived ? nil : [v.name, v.id]
    end.compact
  end

  def slack_emoji_list
    current_user.slack_emoji_list.map {|k, v| k} #todo: 画像urlを使って良い感じにする
  end

  def slack_emoji_url(reminder)
    default_emoji_url = 'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/twitter/185/dog-face_1f436.png'
    current_user.slack_emoji_list[reminder.icon_emoji] || default_emoji_url
  end

  def css_class_status(reminder)
    if reminder.activated?
      'is-primary'
    elsif reminder.deactivated?
      'has-background-grey-light'
    else
      'is-dark'
    end
  end
end
