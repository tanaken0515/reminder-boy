class RenameReminderLogsToRemindLogs < ActiveRecord::Migration[5.2]
  def change
    rename_table :reminder_logs, :remind_logs
  end
end
