class RemindLogsController < ApplicationController
  include RemindLogsHelper

  def index
    @remind_logs = current_user.remind_logs
  end
end
