class CreateWebhooks < ActiveRecord::Migration[5.1]
  def change
    create_table :webhooks do |t|
      t.string :uri, null: false
      t.integer :user_id, null: false
      t.string :name
      t.string :content_hash, null: false

      t.timestamps
    end

    add_index :webhooks, :uri, unique: true
    add_index :webhooks, :user_id
    add_index :webhooks, :content_hash, unique: true
  end
end
