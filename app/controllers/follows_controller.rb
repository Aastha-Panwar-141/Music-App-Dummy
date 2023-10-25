class FollowsController < ApplicationController
  before_action :find_user, only: [:follow, :unfollow]
  
  def follow
    # byebug
    if @current_user.user_type == 'Listener' && @user.user_type == 'Listener'
      return render json: { error: 'Listeners cannot follow other listeners' }, status: :unprocessable_entity
    elsif @current_user.id == @user.id
      return render json: {error: "You can't follow yourself!"}, status: :unprocessable_entity
    elsif @current_user.user_type == 'Artist' && @user.user_type == 'Listener'
      return render json: {error: "Artist can't follow a listener!"}, status: :unprocessable_entity
    else
      if @current_user.followees.include?(@user)
        render json: {error: "You are already following this artist!"}
      else
        @current_user.followees << @user
        render json: @user
      end
    end
  end
  
  def unfollow
    if @already_follows.present?
      if @already_follows.destroy
        render json: @user
      else
        render json: {error: "Request failed!"}, status: :unprocessable_entity
      end
    else
      render json: {error: "You are not following this Artist!"}, status: :unprocessable_entity
    end
  end
  
  def all_followers
    if @current_user.followers.present?
      @followers = @current_user.followers
      render json: @followers
    else
      render json: {error: "You have no followers!"}
    end
  end
  
  def all_followees
    if @current_user.followees.present?
      @followees = @current_user.followees
      render json: @followees
    else
      render json: {error: "You have no followees!"}
    end
  end
  
  
  private
  
  def already_follows
    @already_follows = Follow.find_by(follower: @current_user, followee: @user)
  end
  
  def find_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {error: 'No record found for given id.'}, status: :unprocessable_entity
    end
  end

end
