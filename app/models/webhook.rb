class Webhook < ApplicationRecord
  include ContentHash
  belongs_to :user

  validates :uri, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
