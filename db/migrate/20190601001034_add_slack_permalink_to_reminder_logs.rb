class AddSlackPermalinkToReminderLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :reminder_logs, :slack_permalink, :string
  end
end
