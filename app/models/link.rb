class Link < ApplicationRecord
  belongs_to :commitment

  validates_presence_of :url
end
