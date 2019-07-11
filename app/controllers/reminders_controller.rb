class RemindersController < ApplicationController
  include RemindersHelper

  before_action :set_reminder, only: [:show, :edit, :update, :post_message]
  before_action :set_reminders, only: :index

  def index
  end

  def new
    @reminder = current_user.reminders.new
  end

  def create
    @reminder = current_user.reminders.new(reminder_params)

    if @reminder.save
      redirect_to reminder_path(@reminder)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @reminder.update(reminder_params)
      redirect_to reminder_path(@reminder)
    else
      render :edit
    end
  end

  def post_message
    TestNoticeWorker.perform_async(@reminder.id)
    render status: 200, json: {status: 200, message: "Success"}
  end

  private

  def reminder_params
    param_keys = [:slack_channel_id, :icon_emoji, :icon_name,
                  :message, :scheduled_time, :holiday_included, :status,
                  :monday_enabled, :tuesday_enabled, :wednesday_enabled,
                  :thursday_enabled, :friday_enabled, :saturday_enabled, :sunday_enabled]
    params.require(:reminder).permit(param_keys)
  end

  def set_reminder
    @reminder = current_user.reminders.find(params[:id])
  end

  def set_reminders
    @reminders = current_user.reminders.from_latest
    if @reminders.empty?
      @reminders = [current_user.reminders.new(
        slack_channel_id: current_user.slack_channel_list.first.first,
        icon_name: 'お使いいただきありがとうございます！',
        message: "まだリマインダーを作っていないようですね。\nNew Reminderボタンでリマインダーを作ってみましょう！",
        scheduled_time: Time.zone.now,
      )]
    end
  end
end
