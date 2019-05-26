class User < ApplicationRecord
  has_many :authentications
  has_many :reminders

  validates :name, presence: true

  def self.create_with!(authentication)
    ApplicationRecord.transaction do
      response = Slack::Web::Client.new(token: authentication.access_token).users_identity
      user_params = {
        name: response.dig(:user, :name),
        avatar_url: response.dig(:user, :image_192)
      }
      user = User.create!(user_params)
      authentication.user = user
      authentication.save!

      user
    end
  end

  def slack_channel_list
    authentication = authentications.last

    # ワークスペースごとにcacheする
    key = "slack_channel_list/#{authentication.slack_workspace_id}"
    Rails.cache.fetch(key, expires_in: 1.hours) do
      response = Slack::Web::Client.new(token: authentication.access_token).conversations_list(types: 'public_channel')
      response.ok ? response.channels.index_by(&:id) : {}
    end
  end
end
