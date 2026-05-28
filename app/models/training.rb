class Training < ApplicationRecord
  belongs_to :user
  belongs_to :target

  validates :theme, presence: true
  validates :explanation, presence: true, length: { minimum: 10 }
  validates :target, presence: true

  validate :custom_target_if_needed

  has_one :ai_feedback, dependent: :destroy

  def display_target
    if target&.name == "その他"
      custom_target.presence || "未設定"
    else
      target&.name || "未設定"
    end
  end

  private

  def custom_target_if_needed
    if target&.name == "その他" && custom_target.blank?
      errors.add(:custom_target, "を入力してください")
    end
  end
end
