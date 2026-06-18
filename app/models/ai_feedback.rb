class AiFeedback < ApplicationRecord
  belongs_to :training

  def self.ransackable_attributes(auth_object = nil)
    %w[score]
  end
end
