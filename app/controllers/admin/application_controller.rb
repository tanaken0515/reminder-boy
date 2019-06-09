module Admin
  class ApplicationController < ActionController::Base
    include SessionsHelper

    before_action :admin_required

    private

    def admin_required
      redirect_to root_path unless admin?
    end
  end
end

