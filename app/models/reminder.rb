class Reminder < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :image

  belongs_to :khateeb
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :khateeb

  validates :image, {
    presence: true
  }

  def get_most_recent_likes
    self.likes.order("created_at DESC").limit(LIKES_LIMIT)
  end

  def get_image_url
    url_for(self.image)
  end

  def liked_by?(khateeb)
    self.likers.include?(khateeb)
  end
end