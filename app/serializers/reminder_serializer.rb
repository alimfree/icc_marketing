class ReminderSerializer

  def initialize(reminders:, khateeb:)
    @reminders = reminders
    @khateeb = khateeb
    @serialized_khateeb = KhateebSerializer.new(khateeb: khateeb).serialize()
  end

  def serialize_with_khateeb_as_json
    serialize_with_khateeb.to_json()
  end

  def serialize_with_khateeb
    serialize().merge({ khateeb: @serialized_khateeb })
  end

  def serialize_as_json
    serialize().to_json()
  end
  
  def serialize
    reminders_key = get_reminders_key()
    { reminders_key => serialize_each_reminder() }
  end

  private def get_reminders_key
    is_feed?() ? :reminders : :reminder
  end

  private def serialize_each_reminder
    if is_feed?()
      @reminders.map() { |reminder| serialize_reminder(reminder) }
    else
      serialize_reminder(@reminders)
    end
  end

  private def is_feed?
    @reminders.is_a?(ActiveRecord::AssociationRelation)
  end

  private def serialize_reminder(reminder)
    {
      id: khateeb.id,
      image_url: reminder.get_image_url(),
      caption: reminder.caption,
      most_recent_likes: reminder.get_most_recent_likes(),
      like_count: reminder.likes.length,
      created_at: reminder.created_at,
      liked_by_current_khateeb: reminder.liked_by?(@khateeb),
      author: {
        id: reminder.khateeb.id,
        username: reminder.khateeb.username,
        avatar: reminder.khateeb.get_avatar_url(),
        followed_by_current_khateeb: reminder.khateeb.followed_by?(@khateeb)
      }
    }
  end

end