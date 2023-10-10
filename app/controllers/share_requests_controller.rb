class ShareRequestsController < ApplicationController
  before_action :validate_artist, except: [:create, :all_splits, :all_sent_requests, :purchased_splits]
  before_action :validate_listener, only: [:create, :all_sent_requests, :purchased_splits]
  before_action :find_request, only: [:accept, :reject, :destroy]
  before_action :find_split, only: [:create]
  before_action :check_owner, only: [:accept, :reject]
  before_action :check_status, only: [:accept, :reject]
  
  def index
    share_requests = ShareRequest.all 
    if share_requests.present?
      render json: share_requests
    else
      render json: {error: "There is no share request!"}, status: :unprocessable_entity
    end
  end
  
  def create
    if @split.present?
      share_request = @split.share_requests.new(request_params.merge(receiver_id: @split.receiver_id, request_type: @split.split_type))
      share_request.requester = @current_user
      if (@split.percentage > 0 && share_request.requested_percent < @split.percentage)
        if share_request.save
          render json: {message: "Request sent successfully.", request: share_request}, status: :created
        else
          render json: { error: share_request.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: {error: "Requested shares are not available!"}, status: :unprocessable_entity
      end
    else
      render json: { error: 'No split for given id!' }, status: :unprocessable_entity
    end
  end
  
  def accept
    requester = @share_request.requester
    receiver = @share_request.receiver
    requested_percent = @share_request.requested_percent
    receiver_split = receiver.splits.where(split_type: 'Artist').first
    receiver_split.percentage -= requested_percent
    requester.total_share_percentage += requested_percent
    if receiver_split.save && receiver.save && requester.save
      @share_request.update(status: 'accepted')
      new_split = Split.create!(
        requester_id: receiver.id,
        receiver_id: requester.id,
        split_type: 'Artist',
        percentage: requested_percent
      )
      render json: { message: 'Request accepted.' }
    else
      render json: { error: 'Failed to accept share request!' }, status: :unprocessable_entity
    end
  end  
  
  def reject
    @share_request.status = 'rejected'
    if @share_request.save
      render json: { message: 'Request rejected' }
    else
      render json: { error: 'Failed to reject share request!' }, status: :unprocessable_entity
    end
  end

  # def song_requests
  #   if song_requests = ShareRequest.where(request_type: 'song')
  #     render json: song_requests
  #   else
  #     render json: {error: "No split for song!"}
  #   end
  # end

  # def accept_song_request
  #   song_request = ShareRequest.find(params[:id])
  #   if song_request.request_type == 'song' && song_request.status == 'pending'
  #     song_request.update(status: 'accepted')
  #     render json: { message: 'Song request accepted' }
  #   else
  #     render json: { error: 'Invalid song request or status' }, status: :unprocessable_entity
  #   end
  # end

  # def reject_song_request
  #   song_request = ShareRequest.find(params[:id])
  #   if song_request.request_type == 'song' && song_request.status == 'pending'
  #     song_request.update(status: 'rejected')
  #     render json: { message: 'Song request rejected' }
  #   else
  #     render json: { error: 'Invalid song request or status' }, status: :unprocessable_entity
  #   end
  # end
  
  def destroy
    if @share_request.destroy
      render json: "Request deleted successfully!"
    else
      render json: "Failed to delete!"
    end
  end
  
  def all_splits
    if @current_user.split_requests.present?
      @splits = @current_user.split_requests
      render json: @splits
    else
      render json: {error: "You have no split!"}
    end
  end
  
  def all_share_requests
    if @current_user.share_requests.present?
      @share_requests = @current_user.share_requests
      render json: @share_requests
    else
      render json: {error: "You have no share request!"}
    end
  end
  
  def all_sent_requests
    if @current_user.sent_requests.present?
      @sent_requests = @current_user.sent_requests
      render json: @sent_requests
    else
      render json: {error: "You have no sent request!"}
    end
  end
  
  def purchased_splits
    if @current_user.sent_requests.present?
      @sent_requests = @current_user.sent_requests
      purchased_splits = @sent_requests.where(status: 'accepted')
      if purchased_splits.present?
        render json: purchased_splits
      else
        render json: {error: "No accepted request!"}, status: :unprocessable_entity
      end
    else
      render json: {error: "You have no sent request!"}
    end
  end
  
  private
  
  def find_request
    begin
      # byebug
      @share_request = ShareRequest.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No share request found for given id."}, status: :unprocessable_entity 
    end
  end
  
  def find_split
    begin
      @split = Split.find(params[:split_id])
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No split found for given id."}, status: :unprocessable_entity 
    end
  end
  
  def find_receiver_artist
    begin
      @receiving_artist = User.find(params[:receiver_id])
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No receiving artist found for given id."}, status: :unprocessable_entity 
    end
  end 
  
  def request_owner?(share_request)
    @share_request.receiver_id == @current_user.id
  end
  
  def check_owner
    unless request_owner?(@share_request)
      render json: {error: "You are not authorized for this request!"}, status: :unprocessable_entity
    end
  end
  
  def check_status
    unless @share_request.status == 'pending'
      render json: "Request is not pending"
    end
  end
  
  # def share_params
  #   params.permit(:receiver_id, :requested_percent, :price, :request_type, :split_id)
  # end
  
  def request_params
    params.permit(:price, :requested_percent, :split_id)
  end
  
  def validate_artist
    if @current_user.user_type != 'Artist'
      render json: { error: 'Listener are Not Allowed for this request' }, status: :forbidden
    end
  end 
  
  def validate_listener
    if @current_user.user_type != 'Listener'
      render json: { error: 'Artist are Not Allowed for this request' }, status: :forbidden
    end
  end 
  
end
