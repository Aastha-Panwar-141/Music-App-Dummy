class SongRequestsController < ApplicationController
  before_action :find_split, only: [:create]
  before_action :find_request, only: [:accept, :reject, :destroy, :check_song_owner]
  before_action :check_song_owner, only: [:accept, :reject, :find_request]
  before_action :check_status, only: [:accept, :reject]
  # before_action :find_song
  before_action :validate_listener, only: [:create]
  
  def index
    song_requests = SongRequest.all
    if song_requests.present?
      render json: song_requests
    else
      render json: {error: "No request available!"}
    end
  end
  
  def all_splits
    splits = SongSplit.all
    if splits.present?
      render json: splits
    else
      render json: {error: "No split available!"}
    end
  end
  
  def create
    # byebug
    if @song_split.present?
      song_request = SongRequest.new(request_params)
      song_request.requester = @current_user
      song_request.receiver = @song_split.receiver
      if (@song_split.percentage > 0 && song_request.requested_percent < @song_split.percentage)
        if song_request.save
          render json: song_request, status: :created
        else
          render json: { error: song_request.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: {error: "Requested shares are not available!"}, status: :unprocessable_entity
      end
    else
      render json: { error: 'No split associated with the song.' }, status: :unprocessable_entity
    end
  end
  
  def accept
    byebug
    requester = @song_request.requester
    receiver = @song_request.receiver
    requested_percent = @song_request.requested_percent
    receiver_split = @song_request.song_split
    receiver_split.percentage -= requested_percent
    if receiver_split.save && receiver.save
      new_split = SongSplit.create!(
        requester_id: receiver.id,
        receiver_id: requester.id,
        song_id: receiver_split.song_id,
        percentage: requested_percent
      )
      @song_request.update(status: 'accepted')
      render json: { message: 'Request accepted.' }
    else
      render json: { error: 'Failed to accept share request!' }, status: :unprocessable_entity
    end
  end  
    
  def reject
    @song_request.status = 'rejected'
    if @song_request.save
      render json: { message: 'Request rejected' }
    else
      render json: { error: 'Failed to reject share request!' }, status: :unprocessable_entity
    end
  end

  def all_sent_requests
    # byebug
    if @current_user.song_sent_requests.present?
      @sent_requests = @current_user.song_sent_requests
      render json: @sent_requests
    else
      render json: {error: "You have no sent request!"}
    end
  end

  def all_accepted_request
    # byebug
    if @current_user.song_sent_requests.present?
      @sent_requests = @current_user.song_sent_requests
      purchased_splits = @sent_requests.where(status: 'accepted')
      if purchased_splits.present?
        render json: purchased_splits
      else
        render json: {error: "No accepted request!"}, status: :unprocessable_entity
      end
    else
      render json: {error: "You have no request!"}
    end
  end

  private
  
  def find_split
    begin
      @song_split = SongSplit.find(params[:song_split_id])
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No split found for given id."}, status: :unprocessable_entity 
    end
  end
  
  def find_request
    begin
      @song_request = SongRequest.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No share request found for given id."}, status: :unprocessable_entity 
    end
  end
  
  def check_status
    unless @song_request.status == 'pending'
      render json: "Request is not pending"
    end
  end
  
  def check_song_owner
    unless @song_request.receiver == @current_user
      render json: { error: "You are not authorized to perform this action." }, status: :unauthorized
    end
  end
  
  def request_params
    params.permit(:price, :requested_percent, :song_split_id)
  end
  
  def validate_listener
    if @current_user.user_type != 'Listener'
      render json: { error: 'Artist are Not Allowed for this request' }, status: :forbidden
    end
  end 
end