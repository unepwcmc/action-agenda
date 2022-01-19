class Objective < ApplicationRecord
  has_and_belongs_to_many :commitments

  validates_presence_of :name
end
