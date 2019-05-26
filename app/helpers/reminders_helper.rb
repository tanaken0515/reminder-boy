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
    current_user.slack_channel_list.map{|key, slack_channel| [slack_channel.name, slack_channel.id]} #todo: is_archived=falseだけに絞る
  end
end
