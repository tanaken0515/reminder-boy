class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :login_required
  around_action :set_time_zone

  private

  def login_required
    redirect_to login_path if visitor?
  end

  def set_time_zone
    if user?
      Time.use_zone(current_user.time_zone) { yield }
    else
      yield
    end
  end
end
