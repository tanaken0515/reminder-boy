class Authentication < ApplicationRecord
  belongs_to :user

  validates :slack_workspace_id, presence: true
  validates :slack_user_id, presence: true, uniqueness: { scope: :slack_workspace_id }
  validates :access_token, presence: true

  def self.authorize_url(callback_url)
    params = {
      scope: 'channels:read,emoji:read,chat:write:user',
      client_id: ENV['SLACK_CLIENT_ID'],
      redirect_uri: callback_url
    }
    "https://slack.com/oauth/authorize?#{params.to_query}"
  end
end
