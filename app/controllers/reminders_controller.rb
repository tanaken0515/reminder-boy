class RemindersController < ApplicationController
  def index
  end

  def new
    @reminder = current_user.reminders.new
  end

  def show
  end

  def edit
  end
end
