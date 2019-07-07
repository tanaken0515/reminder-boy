class ThreadReminder < ApplicationRecord
  extend Enumerize

  belongs_to :reminder

  validates :message, presence: true
  enumerize :status, in: { activated: 0, deactivated: 1, archived: 2 },
            default: :activated, predicates: true, scope: true
end
