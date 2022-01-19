class Threat < ApplicationRecord
  has_and_belongs_to_many :criteria

  validates_presence_of :name
  validates_uniqueness_of :name
end