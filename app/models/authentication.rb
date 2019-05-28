class Authentication < ApplicationRecord
  belongs_to :user

  validates :slack_workspace_id, presence: true
  validates :slack_user_id, presence: true, uniqueness: { scope: :slack_workspace_id }
  validates :access_token, presence: true

  def self.authorize_url(callback_url)
    params = {
      scope: 'channels:read,emoji:read,chat:write:bot',
      client_id: ENV['SLACK_CLIENT_ID'],
      redirect_uri: callback_url
    }
    "https://slack.com/oauth/authorize?#{params.to_query}"
  end

  def update_access_token!(new_access_token)
    if access_token != new_access_token
      begin
        Slack::Web::Client.new(token: access_token).auth_revoke
        Rails.logger.info "[completed] to revoke access token. authentication_id=#{id}"
      rescue => e
        Rails.logger.error "[failed] to revoke access token. authentication_id=#{id}"
        Rails.logger.error e
      end
      update!(access_token: new_access_token)
    end
  end
end
