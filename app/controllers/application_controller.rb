class ApplicationController < ActionController::API

  unless Rails.env.development?()
    rescue_from ActionController::ParameterMissing do |error|
      render json: { errors: "Parameter missing" }, status: 400
    end

    rescue_from ICCMarketingErrors::Unauthorizedkhateeb do |error|
      render json: { errors: error.message }, status: error.http_status
    end
  end

  def get_current_khateeb
    begin
      khateeb_id = decode_token()["khateeb_id"]
      Khateeb.find(khateeb_id)
    rescue
      raise ICCMarketingErrors::Unauthorizedkhateeb
    end
  end

  def issue_token(data)
    JWT.encode(data, get_secret())
  end

  def decode_token
    token = request.headers["Authorization"]
    JWT.decode(token, get_secret()).first
  end

  private def get_secret
    ENV["ICC_MAKRETING_JWT_KEY"]
  end

  private def get_feed_start_datetime
    if params[:earliest_date_in_feed]
      params[:earliest_date_in_feed]
    else
      DateTime.now()
    end
  end 

  private def respond_to_error(error)
    render json: { errors: error.message }, status: error.http_status
  end

end