class ReminderLogsController < ApplicationController
  include ReminderLogsHelper

  def index
    @remind_logs = current_user.remind_logs
  end
end
