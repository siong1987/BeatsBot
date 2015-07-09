class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :slack_user_id, null: false
      t.string :slack_webhook_url
      t.boolean :enabled, default: true
    end

    add_index :users, :slack_user_id, unique: true
  end
end
