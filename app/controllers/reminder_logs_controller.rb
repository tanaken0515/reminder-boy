class ReminderLogsController < ApplicationController
  include ReminderLogsHelper

  def index
    @reminder_logs = current_user.reminder_logs
  end
end
