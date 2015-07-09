class CreateBeats < ActiveRecord::Migration
  def change
    create_table :beats do |t|
      t.string :title, null: false
      t.string :artist, null: false
      t.string :url

      t.timestamps null: false
    end
  end
end
