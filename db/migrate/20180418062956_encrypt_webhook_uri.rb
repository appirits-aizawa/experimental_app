class EncryptWebhookUri < ActiveRecord::Migration[5.1]
  def change
    Webhook.destroy_all
    remove_index :webhooks, column: %i[uri user_id], unique: true
    remove_column :webhooks, :uri, :string, null: false
    add_column :webhooks, :encrypted_uri, :string, null: false
  end
end
