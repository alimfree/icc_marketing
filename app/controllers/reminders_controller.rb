class RemindersController < ApplicationController

  #Refactor into master error controller?
  unless Rails.env.development?()
    rescue_from class remindersController < ApplicationController

  #Refactor into master error controller?
  unless Rails.env.development?()
    rescue_from ICCMarketingErrors::reminderNotFound do |error|
      respond_to_error(error)
    end

    rescue_from ICCMarketingErrors::reminderAlreadyLiked do |error|
      respond_to_error(error)
    end

    rescue_from ICCMarketingErrors::LikeNotFound do |error|
      respond_to_error(error)
    end
  end

  def show_feed
    @khateeb = get_current_khateeb()
    start_datetime = get_feed_start_datetime()
    feed = @khateeb.get_followed_feed(start_datetime)
    serializer = ReminderSerializer.new(reminders: feed, khateeb: @khateeb)
    response = serializer.serialize_with_khateeb_as_json()
    render json: response, status: 200
  end

  def create
    @khateeb = get_current_khateeb()
    params[:khateeb_id] = @khateeb.id
    @reminder = reminder.create(reminder_params())
    respond_to_reminder()
  end

  #Can FormData be set as the value of a "reminder" key?
  private def reminder_params
    params.permit(:khateeb_id, :caption, :image)
  end

  private def respond_to_reminder()
    if @reminder.valid?()
      reminder_serializer = reminderSerializer.new(reminders: @reminder, khateeb: @khateeb)
      response = reminder_serializer.serialize_with_khateeb_as_json()
      render json: response, status: 200
    else
      render json: { errors: reminder.errors }, status: 400
    end
  end

  def like
    @khateeb = get_current_khateeb()
    @reminder = get_reminder_from_params()
    params[:khateeb_id] = @khateeb.id
    @like = Like.create(like_params())
    respond_to_like_toggle()
  end

  def unlike
    @khateeb = get_current_khateeb()
    @reminder = get_reminder_from_params()
    @like = Like.find_by(khateeb_id: @khateeb.id, reminder_id: @reminder.id)
    # Is it better to raise the error with an if, or rescue the error when it occurs?
    if !@like
      raise ICCMarketingErrors::LikeNotFound
    end
    @like.destroy()
    respond_to_like_toggle()
  end

  private def get_reminder_from_params
    begin
      reminder.find(params[:reminder_id])
    rescue ActiveRecord::RecordNotFound
      raise ICCMarketingErrors::reminderNotFound
    end
  end

  private def like_params
    params.permit(:khateeb_id, :reminder_id)
  end

  private def respond_to_like_toggle()
    if @like.valid?()
      reminder_serializer = reminderSerializer.new(reminders: @reminder, khateeb: @khateeb)
      response = reminder_serializer.serialize_as_json()
      render json: response
    else
      render json: { errors: @like.errors }, status: 400
    end
  end

ends::reminderNotFound do |error|
      respond_to_error(error)
    end

    rescue_from ICCMarketingErrors::reminderAlreadyLiked do |error|
      respond_to_error(error)
    end

    rescue_from ICCMarketingErrors::LikeNotFound do |error|
      respond_to_error(error)
    end
  end

  def show_feed
    @khateeb = get_current_khateeb()
    start_datetime = get_feed_start_datetime()
    feed = @khateeb.get_followed_feed(start_datetime)
    serializer = reminderSerializer.new(reminders: feed, khateeb: @khateeb)
    response = serializer.serialize_with_khateeb_as_json()
    render json: response, status: 200
  end

  def create
    @khateeb = get_current_khateeb()
    params[:khateeb_id] = @khateeb.id
    @reminder = reminder.create(reminder_params())
    respond_to_reminder()
  end

  #Can FormData be set as the value of a "reminder" key?
  private def reminder_params
    params.permit(:khateeb_id, :caption, :image)
  end

  private def respond_to_reminder()
    if @reminder.valid?()
      reminder_serializer = reminderSerializer.new(reminders: @reminder, khateeb: @khateeb)
      response = reminder_serializer.serialize_with_khateeb_as_json()
      render json: response, status: 200
    else
      render json: { errors: reminder.errors }, status: 400
    end
  end

  def like
    @khateeb = get_current_khateeb()
    @reminder = get_reminder_from_params()
    params[:khateeb_id] = @khateeb.id
    @like = Like.create(like_params())
    respond_to_like_toggle()
  end

  def unlike
    @khateeb = get_current_khateeb()
    @reminder = get_reminder_from_params()
    @like = Like.find_by(khateeb_id: @khateeb.id, reminder_id: @reminder.id)
    # Is it better to raise the error with an if, or rescue the error when it occurs?
    if !@like
      raise SupagramErrors::LikeNotFound
    end
    @like.destroy()
    respond_to_like_toggle()
  end

  private def get_reminder_from_params
    begin
      reminder.find(params[:reminder_id])
    rescue ActiveRecord::RecordNotFound
      raise SupagramErrors::reminderNotFound
    end
  end

  private def like_params
    params.permit(:khateeb_id, :reminder_id)
  end

  private def respond_to_like_toggle()
    if @like.valid?()
      reminder_serializer = reminderSerializer.new(reminders: @reminder, khateeb: @khateeb)
      response = reminder_serializer.serialize_as_json()
      render json: response
    else
      render json: { errors: @like.errors }, status: 400
    end
  end

end