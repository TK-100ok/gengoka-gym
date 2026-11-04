class Training < ApplicationRecord
  belongs_to :user
  belongs_to :target

  validates :theme, presence: true
  validates :explanation, presence: true, length: { minimum: 10, maximum: 600 }
  validates :target, presence: true

  validate :custom_target_if_needed

  has_one :ai_feedback, dependent: :destroy
  has_one :post, dependent: :destroy

  has_many :favorites, dependent: :destroy

  # 他ユーザーが閲覧できるのは投稿中のトレーニングのみ。自分のトレーニングは常に閲覧できる
  scope :visible_to, ->(user) {
    left_joins(:post).where("posts.id IS NOT NULL OR trainings.user_id = ?", user.id)
  }

  def display_target
    if target&.name == "その他"
      custom_target.presence || "未設定"
    else
      target&.name || "未設定"
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[theme explanation created_at target_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[target ai_feedback]
  end

  private

  def custom_target_if_needed
    if target&.name == "その他" && custom_target.blank?
      errors.add(:custom_target, "を入力してください")
    end
  end
end
