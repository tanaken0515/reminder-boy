class CreateAuthentications < ActiveRecord::Migration[5.2]
  def change
    create_table :authentications do |t|
      t.references :user, foreign_key: true

      t.string :slack_workspace_id, null: false
      t.string :slack_user_id, null: false
      t.string :access_token, null: false

      t.timestamps
    end
  end
end
