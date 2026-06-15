class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :training

  validates :user_id, uniqueness: { scope: :training_id }
end
