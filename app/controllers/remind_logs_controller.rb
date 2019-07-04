class RemindLogsController < ApplicationController
  include RemindLogsHelper

  def index
    @remind_logs = current_user.remind_logs.from_latest.page(params[:page]).per(5)
  end
end
