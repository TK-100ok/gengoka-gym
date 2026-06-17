class Target < ApplicationRecord
  has_many :trainings

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
