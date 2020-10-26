class Operator < ApplicationRecord
  acts_as_paranoid
  extend Enumerize
  enumerize :role, in: { general: 0, admin: 1 }, default: :general, predicates: true, scope: true
  attr_accessor :remember_token, :reset_password_token

  has_secure_password
  validates :email, presence: true, length: { maximum: 191 }, uniqueness: true
  has_many :articles, dependent: :destroy
  has_many :daily_user_summaries, dependent: :destroy
  has_many :weekly_user_summaries, dependent: :destroy
  has_many :monthly_user_summaries, dependent: :destroy

  # 渡された文字列をハッシュ化して返す
  # min_cost == trueになるのはテスト時
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにトークンをDBに保存する
  def remember
    self.remember_token = Operator.new_token
    update(remember_digest: Operator.digest(remember_token), remember_created_at: Time.zone.now)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update(remember_digest: nil, remember_created_at: nil)
  end

  def create_reset_password_token
    self.reset_password_token = Operator.new_token
    update!(reset_password_token_digest: Operator.digest(reset_password_token), reset_password_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_password_sent_at < 1.hour.ago
  end
end
