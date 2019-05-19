class User < ApplicationRecord
  has_many :authentications

  validates :name, presence: true

  def self.create_with(authentication)
    # todo: (必要なら)access_tokenを使ってuser_nameとavatar_urlを取ってくる
    user_params = {
      name: 'todo',
      avatar_url: 'todo'
    }

    ApplicationRecord.transaction do
      user = User.create(user_params)
      authentication.user = user
      authentication.save
    end
  end
end
