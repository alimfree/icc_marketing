class reminderSerializer

  def initialize(reminders:, user:)
    @reminders = reminders
    @user = user
    @serialized_user = UserSerializer.new(user: user).serialize()
  end

  def serialize_with_user_as_json
    serialize_with_user.to_json()
  end

  def serialize_with_user
    serialize().merge({ user: @serialized_user })
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
      id: reminder.id,
      image_url: reminder.get_image_url(),
      caption: reminder.caption,
      most_recent_likes: reminder.get_most_recent_likes(),
      like_count: reminder.likes.length,
      created_at: reminder.created_at,
      liked_by_current_user: reminder.liked_by?(@user),
      author: {
        id: reminder.user.id,
        username: reminder.user.username,
        avatar: reminder.user.get_avatar_url(),
        followed_by_current_user: reminder.user.followed_by?(@user)
      }
      title: reminder.title
    }
  end

end