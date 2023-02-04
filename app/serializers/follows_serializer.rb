class FollowSerializer

  def initialize(follow, khateeb)
    @followed = follow.followed
    @khateeb = khaeeb
  end

  def serialize
    {
      khateeb: {
        id: @followed.id,
        username: @followed.username,
        followed_by_current_khateeb: @followed.followed_by?(@khateeb)
      }
    }.to_json()
  end

end