class Webhook < ApplicationRecord
  include ContentHash
  belongs_to :user

  validates :uri, presence: true, uniqueness: { scope: :user_id }
  validates :name, presence: true, uniqueness: { scope: :user_id }
end
