class KhateebSerializer

  def initialize(khateeb:)
    @khateeb = khateeb
  end

  def serialize_with_auth_token_as_json(token)
    serialize_with_auth_token(token).to_json()
  end

  private def serialize_with_auth_token(token)
    { 
      khateeb: serialize(),
      token: token
    }
  end

  def serialize
    {
      username: @khateeb.username,
      avatar: @khateeb.get_avatar_url(),
      post_count: @khateeb.get_post_count(),
      follower_count: @khateeb.get_follower_count(),
      followed_count: @khateeb.get_followed_count()
    }
  end

end