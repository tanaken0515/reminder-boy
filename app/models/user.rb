class User < ApplicationRecord
  has_many :authentications
  has_many :reminders

  validates :name, presence: true

  def self.create_with!(authentication, user_params)
    ApplicationRecord.transaction do
      user = User.create!(user_params)
      authentication.user = user
      authentication.save!

      user
    end
  end
end
