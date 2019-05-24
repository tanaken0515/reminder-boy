class RemindersController < ApplicationController
  def index
  end

  def new
    @reminder = current_user.reminders.new
    @slack_channel_list = [%w(ch1_name ch1_id), %w(ch2_name ch2_id), %w(ch3_name ch3_id)] #todo: apiで取ってくる
  end

  def show
  end

  def edit
  end
end
