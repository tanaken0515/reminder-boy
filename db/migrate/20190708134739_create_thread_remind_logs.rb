class CreateThreadRemindLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :thread_remind_logs do |t|
      t.references :thread_reminder, foreign_key: true

      t.string :slack_channel_id, null: false
      t.string :icon_emoji
      t.string :icon_name
      t.string :message, null: false
      t.string :slack_message_ts, null: false
      t.string :slack_permalink
      t.string :emoji_url

      t.timestamps
    end
  end
end
