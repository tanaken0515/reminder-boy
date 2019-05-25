class RemindersController < ApplicationController
  include RemindersHelper

  before_action :set_slack_channel_list, only: [:new, :edit]
  before_action :set_reminder, only: [:show, :edit, :update]

  def index
    @reminders = current_user.reminders
  end

  def new
    @reminder = current_user.reminders.new
  end

  def create
    @reminder = current_user.reminders.new(reminder_params)

    if @reminder.save
      redirect_to reminders_path
    else
      set_slack_channel_list
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
      set_slack_channel_list
      render :edit
    end
  end

  private

  def reminder_params
    param_keys = [:slack_channel_id, :icon_emoji, :icon_name,
                  :message, :hour, :minute, :holiday_included, :status,
                  :monday_enabled, :tuesday_enabled, :wednesday_enabled,
                  :thursday_enabled, :friday_enabled, :saturday_enabled, :sunday_enabled]
    params.require(:reminder).permit(param_keys)
  end

  def set_slack_channel_list
    @slack_channel_list = [%w(ch1_name ch1_id), %w(ch2_name ch2_id), %w(ch3_name ch3_id)] #todo: apiで取ってくる
  end

  def set_reminder
    @reminder = current_user.reminders.find(params[:id])
  end
end
