class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable,
         omniauth_providers: [:google_oauth2]

  validates :name, presence: true

  has_many :trainings, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_trainings, through: :favorites, source: :training

  def favorite(training)
    favorite_trainings << training
  end

  def unfavorite(training)
    favorite_trainings.destroy(training)
  end

  def favorite?(training)
    favorite_trainings.include?(training)
  end

  def self.from_omniauth(auth)
    # Google側でメールアドレスが認証されていなければ拒否
    return nil if auth.provider == "google_oauth2" && !auth.info.email_verified

    # このアプリではメールアドレスが必須
    return nil if auth.info.email.blank?

    # 既存のGoogleユーザーなら、そのユーザーでログイン
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # 既存のメールアドレスユーザーとは自動的に連携しない
    return nil if exists?(email: auth.info.email)

    # 初回のGoogleログインなので新規ユーザーを作成
    create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name.presence || "Googleユーザー"
      user.password = SecureRandom.hex(16)
    end
  end

  # Googleログインユーザーにはパスワードを要求しない
  def password_required?
    super && provider.blank?
  end

  def password_changeable?
    provider.blank?
  end
end
