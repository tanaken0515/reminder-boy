class SessionsController < ApplicationController
  def new
    @authorize_url = Authentication.authorize_url(callback_url)
  end

  def create
  end

  def destroy
  end
end
