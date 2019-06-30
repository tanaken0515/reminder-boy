FactoryBot.define do
  factory :user do
    name { 'taro' }
    time_zone { 'Asia/Tokyo' }

    factory :user_with_authentication do
      after(:create) do |user|
        user.authentications << FactoryBot.build(:authentication)
        user.save
      end
    end
  end
end
