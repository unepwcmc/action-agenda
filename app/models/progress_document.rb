class ProgressDocument < ApplicationRecord
  belongs_to :commitment

  has_one_attached :document

  validates :document, attached: true, content_type: %w(application/msword application/pdf), size: { less_than: 25.megabytes }
end