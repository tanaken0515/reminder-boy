class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
    @authorize_url = Authentication.authorize_url(callback_url)
  end

  def create
    if params.include?(:error)
      message = (params[:error] == 'access_denied') ? 'キャンセルされました' : 'エラーが発生しました'
      redirect_to login_url, notice: message
      return
    end

    response = oauth_access(params[:code])

    access_token = response.dig(:access_token)
    authentication_params = {
      slack_workspace_id: response.dig(:team_id),
      slack_user_id: response.dig(:user_id)
    }
    authentication = Authentication.find_or_initialize_by(authentication_params)

    if authentication.new_record?
      authentication.access_token = access_token
      user = User.create_with!(authentication, response.dig(:user_id))

      login(user)
    else
      authentication.update_access_token!(access_token)

      login(authentication.user)
    end

    redirect_to root_path
  end

  def destroy
    logout

    redirect_to root_path
  end

  private

  def oauth_access(code)
    oauth_access_params = {
      client_id: ENV['SLACK_CLIENT_ID'],
      client_secret: ENV['SLACK_API_SECRET'],
      redirect_uri: callback_url,
      code: code
    }
    Slack::Web::Client.new.oauth_access(oauth_access_params)
  end

end
