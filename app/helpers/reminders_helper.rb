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
end
