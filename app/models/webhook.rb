class Webhook < ApplicationRecord
  include ContentHash
  belongs_to :user

  validates :uri, presence: true, uniqueness: { scope: :user_id }
  validates :name, presence: true, uniqueness: { scope: :user_id }

  def slack_url
    Rails.application.routes.url_helpers.exec_api_gitlab_path(content_hash: content_hash)
  end
end
