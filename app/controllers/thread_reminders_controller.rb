class ThreadRemindersController < ApplicationController
  before_action :set_reminder, only: [:new, :create]

  def new
    @thread_reminder = @reminder.thread_reminders.new
  end

  def create
    @thread_reminder = @reminder.thread_reminders.new(thread_reminder_params)

    if @thread_reminder.save
      redirect_to reminder_path(@reminder)
    else
      render :new
    end
  end

  private

  def set_reminder
    @reminder = current_user.reminders.find(params[:id])
  end

  def thread_reminder_params
    param_keys = [:icon_emoji, :icon_name, :message, :scheduled_time,
                  :also_send_to_channel, :holiday_included, :status,
                  :monday_enabled, :tuesday_enabled, :wednesday_enabled,
                  :thursday_enabled, :friday_enabled, :saturday_enabled, :sunday_enabled]
    params.require(:thread_reminder).permit(param_keys)
  end
end
