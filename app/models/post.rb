class Post < ApplicationRecord
  belongs_to :user
  belongs_to :training

  validates :training_id, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id training_id user_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[training]
  end
end
