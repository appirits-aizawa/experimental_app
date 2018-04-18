class Webhook < ApplicationRecord
  include ContentHash
  belongs_to :user
  attr_accessor :uri
  before_save :encrypt_uri

  validates :uri, presence: true, if: :new_record?
  validates :name, presence: true, uniqueness: { scope: :user_id }

  def slack_url
    Rails.application.routes.url_helpers.exec_api_gitlab_path(content_hash: content_hash)
  end

  def decrypted_uri
    encryptor.decrypt_and_verify(encrypted_uri)
  end

  private

  def encryptor
    secret = Settings.encryption_key
    ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
  end

  def encrypt_uri
    return if uri.blank?
    self.encrypted_uri = encryptor.encrypt_and_sign(uri)
  end
end
