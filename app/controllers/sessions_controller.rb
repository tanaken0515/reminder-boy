class SessionsController < ApplicationController
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

    slack_workspace_id = response.dig(:team_id)
    slack_user_id = response.dig(:authorizing_user, :user_id)
    authentication = Authentication.find_or_initialize_by(slack_workspace_id: slack_workspace_id, slack_user_id: slack_user_id)

    if authentication.new_record?
      authentication.access_token = response.dig(:access_token)
      user = User.create_with(authentication)
      login(user)
    else
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
    # todo: slack-api-client を用意する
    # client = apiクライアントをnewする
    # response = client.oauth_access(
    #   {
    #     client_id: ENV['SLACK_CLIENT_ID'],
    #     client_secret: ENV['SLACK_API_SECRET'],
    #     redirect_uri: callback_url,
    #     code: code
    #   }
    # )
    { team_id: 'aaaaa', authorizing_user: {user_id: 'bbbbb'}, access_token: 'ccccc' }
  end

end
