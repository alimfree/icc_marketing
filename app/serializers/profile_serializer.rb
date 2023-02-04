class ProfileSerializer

  def initialize(profile:, profile_owner:, current_khateeb:)
    @reminder_serializer = ReminderSerializer.new(reminders: profile, khateeb: current_khateeb)
    @khateeb_serializer = KhateebSerializer.new(khateeb: profile_owner)
  end

  def serialize_as_json
    serialize.to_json()
  end

  private def serialize
    serialized_reminders = @reminder_serializer.serialize_with_khateeb
    serialized_profile_owner = @khateeb_serializer.serialize()
    serialized_reminders.merge({ profile_owner: serialized_profile_owner })
  end

end