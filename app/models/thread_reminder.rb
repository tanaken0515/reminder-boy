class ThreadReminder < ApplicationRecord
  extend Enumerize

  belongs_to :reminder

  validates :message, presence: true
  enumerize :status, in: { activated: 0, deactivated: 1, archived: 2 },
            default: :activated, predicates: true, scope: true

  # custom validations
  validate :validate_scheduled_time_is_included_in_scheduled_time_list

  def self.scheduled_time_list
    hour_list = (0..23).to_a
    minute_list = (0..59).step(5)

    scheduled_time_list = []
    hour_list.each do |hour|
      minute_list.each do |minute|
        scheduled_time_list << format('%02d:%02d', hour, minute)
      end
    end

    scheduled_time_list.map(&:freeze).freeze
  end

  private

  def validate_scheduled_time_is_included_in_scheduled_time_list
    unless ThreadReminder.scheduled_time_list.include?(scheduled_time.try(:strftime, '%H:%M'))
      errors.add(:scheduled_time, 'is not included in scheduled time list')
    end
  end
end
