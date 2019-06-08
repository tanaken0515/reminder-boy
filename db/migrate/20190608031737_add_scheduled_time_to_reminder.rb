class AddScheduledTimeToReminder < ActiveRecord::Migration[5.2]
  def change
    add_column :reminders, :scheduled_time, :time, default: '00:00', null: false
  end
end
