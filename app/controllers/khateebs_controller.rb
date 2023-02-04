class KhateebsController < ApplicationController

  def create
    @khateeb = get_current_user()
    params[:user_id] = @user.id

    @khateeb = Post.create(post_params())
    respond_to_post()
  end

  private 
  
  def post_params
    params.permit(:first_nm, :last_nm, :title, :email, :phone_number, :image)
  end

  def respond_to_post()
    if @post.valid?()
      post_serializer = PostSerializer.new(post: @post, user: @user)
      render json: post_serializer.serialize_new_post()
    else
      render json: { errors: post.errors }, status: 400
    end
  end
  
end