FactoryBot.define do
  factory :reminder do
    message { 'test' }
    slack_channel_id { 'C*****1' }
    scheduled_time { '09:00' }

    association :user
  end
end
