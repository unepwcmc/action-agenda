class Stakeholder < ApplicationRecord
  has_and_belongs_to_many :criteria

  validates_presence_of :name
end