require 'active_support/concern'
# require 'securerandom'

module ContentHash
  extend ActiveSupport::Concern

  included do
    before_create :set_generated_content_hash
    validates :content_hash, uniqueness: true
    validates :content_hash, presence: true, unless: :new_record?
    validate :check_content_hash_is_not_changed, unless: :new_record?
  end

  def set_generated_content_hash
    self.content_hash = random_hash
  end

  # ハッシュが後から変更されないことの確認
  def check_content_hash_is_not_changed
    return unless content_hash_changed?
    errors.add(:content_hash, :changed)
  end

  # 毎回ランダム値を生成
  def random_hash
    "#{SecureRandom.hex(8)}#{Time.zone.now.strftime('%Y%m%d%H%M%S')}"
  end
end
