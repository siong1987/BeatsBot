class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :url
      t.boolean :enabled, default: true

      t.timestamps null: false
    end

    add_index :webhooks, :url, unique: true
  end
end
