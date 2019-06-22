class DeleteHourAndMinuteFromReminder < ActiveRecord::Migration[5.2]
  def up
    remove_column :reminders, :hour
    remove_column :reminders, :minute
  end

  def down
    add_column :reminders, :hour, :integer, null: false, default: 0
    add_column :reminders, :minute, :integer, null: false, default: 0
  end
end
