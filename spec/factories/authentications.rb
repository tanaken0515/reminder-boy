FactoryBot.define do
  factory :authentication do
    slack_workspace_id {'T*****'}
    slack_user_id {'U*****'}
    access_token {'xoxp-******'}

    association :user
  end
end

