class Country < ApplicationRecord
  has_many :commitments, class_name: "Commitment"
  validates :name, presence: true
  validates :name, uniqueness: true
end
