class Authentication < ApplicationRecord
  belongs_to :user

  validates :slack_workspace_id, presence: true
  validates :slack_user_id, presence: true, uniqueness: { scope: :slack_workspace_id }
  validates :access_token, presence: true
end
