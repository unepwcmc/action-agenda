class Post2020Target < ApplicationRecord
  has_many :post2020_targets_commitment_activities
  has_many :objectives, through: :post2020_targets_commitment_activities, source: :commitment_activity, source_type: 'Objective'
  has_many :threats, through: :post2020_targets_commitment_activities, source: :commitment_activity, source_type: 'Threat'
  
  validates_presence_of :name
  validates_uniqueness_of :name

  def commitment_activities
    (objectives + threats).unique
  end

  def commitment_statistics
    # method to
      # join self to managers via commitments
      # calculate percentage of manager type by self
  end

  def icon_url
    # Rails.application.routes.url_helpers.image_url(#{ image_location })
  end
end
