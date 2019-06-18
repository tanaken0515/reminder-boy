class AddEmojiUrlToRemindLog < ActiveRecord::Migration[5.2]
  def change
    add_column :remind_logs, :emoji_url, :string
  end
end
