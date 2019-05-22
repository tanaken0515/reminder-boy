class Reminder < ApplicationRecord
  belongs_to :user

  validates :slack_channel_id, presence: true
  validates :message, presence: true
  validates :hour, presence: true
  validates :minute, presence: true
  validates :holiday_included, presence: true
  validates :status, presence: true

  validates :monday_enabled, presence: true
  validates :tuesday_enabled, presence: true
  validates :wednesday_enabled, presence: true
  validates :thursday_enabled, presence: true
  validates :friday_enabled, presence: true
  validates :saturday_enabled, presence: true
  validates :sunday_enabled, presence: true
end
