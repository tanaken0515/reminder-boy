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
    key = "slack_channel_list/#{latest_authentication.slack_workspace_id}"

    Rails.cache.fetch(key, expires_in: 1.hours) do
      response = slack_client.conversations_list(types: 'public_channel')
      response.ok ? response.channels.index_by(&:id) : {}
    end
  end

  def slack_emoji_list
    key = "slack_emoji_list/#{latest_authentication.slack_workspace_id}"

    Rails.cache.fetch(key, expires_in: 1.hours) do
      response = slack_client.emoji_list
      response.ok ? response.emoji : {}
    end
  end

  def latest_authentication
    @authentication ||= authentications.last
  end

  def slack_client
    @client ||= Slack::Web::Client.new(token: latest_authentication.access_token)
  end
end
