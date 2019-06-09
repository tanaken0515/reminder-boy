class User < ApplicationRecord
  extend Enumerize

  has_many :authentications
  has_many :reminders
  has_many :remind_logs, through: :reminders

  validates :name, presence: true
  enumerize :role, in: {none: 0, admin: 1},
            default: :none, predicates: {prefix: true}, scope: true

  def self.create_with!(authentication)
    ApplicationRecord.transaction do
      response = Slack::Web::Client.new(token: authentication.access_token).users_profile_get
      user_params = {
        name: response.dig(:profile, :real_name),
        avatar_url: response.dig(:profile, :image_192)
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
