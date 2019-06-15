module Admin
  class ApplicationController < ActionController::Base
    include SessionsHelper

    before_action :admin_required
    around_action :set_time_zone

    private

    def admin_required
      redirect_to root_path unless admin?
    end

    def set_time_zone
      if user?
        Time.use_zone(current_user.time_zone) { yield }
      else
        yield
      end
    end
  end
end

