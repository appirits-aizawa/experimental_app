class AlterIndexOnWebhooks < ActiveRecord::Migration[5.1]
  def change
    remove_index :webhooks, column: :uri, unique: true
    remove_index :webhooks, column: :user_id
    add_index :webhooks, %i[uri user_id], unique: true
  end
end
