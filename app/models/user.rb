class User < ApplicationRecord
  has_many :authentications

  validates :name, presence: true
end
