class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
end
