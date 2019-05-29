class CreateReminderLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :reminder_logs do |t|
      t.references :reminder, foreign_key: true

      t.string :slack_channel_id, null: false
      t.string :icon_emoji
      t.string :icon_name
      t.string :message, null: false
      t.string :slack_message_ts, null: false

      t.timestamps
    end
  end
end
