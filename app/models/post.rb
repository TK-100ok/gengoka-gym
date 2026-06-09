class Post < ApplicationRecord
  belongs_to :user
  belongs_to :training
  
  validates :training_id, uniqueness: true
end
