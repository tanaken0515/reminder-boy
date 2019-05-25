class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.references :user, foreign_key: true

      t.string :slack_channel_id, null: false
      t.string :icon_emoji
      t.string :icon_name
      t.string :message, null: false
      t.integer :hour, null: false
      t.integer :minute, null: false
      t.boolean :holiday_included, null: false, default: false
      t.integer :status, limit: 2, null: false

      t.boolean :monday_enabled, null: false, default: false
      t.boolean :tuesday_enabled, null: false, default: false
      t.boolean :wednesday_enabled, null: false, default: false
      t.boolean :thursday_enabled, null: false, default: false
      t.boolean :friday_enabled, null: false, default: false
      t.boolean :saturday_enabled, null: false, default: false
      t.boolean :sunday_enabled, null: false, default: false

      t.timestamps
    end
  end
end
