class Khateeb < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ValidationRegexps
  include ValidationErrorMessages

  has_one_attached :avatar

  has_many :reminders, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follows_as_follower, foreign_key: :follower_id, class_name: :Follow, dependent: :destroy
  has_many :follows_as_followed, foreign_key: :followed_id, class_name: :Follow, dependent: :destroy
  has_many :followed, through: :follows_as_follower, class_name: :khateeb
  has_many :followers, through: :follows_as_followed, class_name: :khateeb
  has_many :followed_reminders, through: :followed, source: :reminders

  has_secure_password

  validates :first_nm, :username, :email, :password, {
    presence: true
  }

  validates :name, {
    format: NAME_REGEXP
  }

  validates :username, {
    uniqueness: true,
    format: {
      with: USERNAME_REGEXP,
      message: USERNAME_MESSAGE
    }
  }

  validates :email, {
    uniqueness: true,
    format: {
      with: URI::MailTo::EMAIL_REGEXP
    }
  }

  validates :password, {
    format: {
      with: PASSWORD_REGEXP,
      message: PASSWORD_MESSAGE
    }
  }

  before_save :format_name
  after_create :attach_default_avatar, :follow_self

  private def format_name
    lowercase_name = self.title.downcae() + " " + self.first_nm.downcase() + " " + self.last_nm.downcase()
    capitalized_words = lowercase_name.split(" ").map() do |word|
      word.capitalize()
    end
    @name = capitalized_words.join(" ")
  end

  private def name
    @name
  end

  private def attach_default_avatar
    avatar_path = "#{::Rails.root}/storage/defaults/default_avatar.png"
    self.avatar.attach(io: File.open(avatar_path), filename: "default_avatar.png", content_type: "image/png")
  end

  private def follow_self
    Follow.create(follower_id: self.id, followed_id: self.id)
  end

  def get_avatar_url
    url_for(self.avatar)
  end

  def get_reminder_count
    self.reminders.length
  end

  def get_follower_count
    self.followers.length
  end

  def get_followed_count
    self.followed.length
  end

  def followed_by?(khateeb)
    self.followers.include?(khateeb)
  end

  def get_followed_feed(start_datetime)
    self.followed_reminders
      .where("reminders.created_at < ?", start_datetime)
      .order(created_at: :desc)
      .limit(25)
  end

  def get_profile_feed(start_datetime)
    self.reminders
      .where("reminders.created_at < ?", start_datetime)
      .order(created_at: :desc)
      .limit(25)
  end

  def get_avatar_url
    url_for(self.avatar)
  end

end