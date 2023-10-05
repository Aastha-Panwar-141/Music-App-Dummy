class ShareRequestsController < ApplicationController
  before_action :validate_artist
  before_action :find_request, only: [:accept, :reject, :destroy]
  before_action :check_owner, only: [:accept, :reject]
  before_action :check_status, only: [:accept, :reject]
  before_action :find_receiver_artist, only: [:create]
  
  def index
    share_requests = ShareRequest.all 
    if share_requests.present?
      render json: share_requests
    else
      render json: {error: "There is no share request!"}, status: :unprocessable_entity
    end
  end
  
  def create
    @split = Split.find(params[:split_id])
    if @split.present?
      share_request = @split.share_requests.new(request_params)
      share_request.requester = @current_user
      if share_request.save
        render json: share_request, status: :created
      else
        render json: { error: share_request.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No split for given id!' }, status: :unprocessable_entity
    end
  end
  
  
  
  
  
  def create
    share_request = ShareRequest.new(
      requesting_artist: @current_user,
      receiving_artist: @receiving_artist,
      requested_percent: params[:requested_percent],
      price: params[:price],
      status: 'pending',
      request_type: params[:request_type],
      split_id: params[:split_id]
    )
    unless share_request.receiving_artist == @current_user
      if share_request.save
        render json: {result: "Deal Request sent successfully!", created_request: share_request}, status: :created
      else
        render json: {error: share_request.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {error: "You can't request to yourself!"}, status: :unprocessable_entity
    end
  end
  
  def accept
    requesting_artist = @share_request.requesting_artist
    receiving_artist = @share_request.receiving_artist
    requested_percentage = @share_request.requested_percent
    requesting_artist.total_share_percentage += requested_percentage
    receiving_artist.total_share_percentage -= requested_percentage
    if requesting_artist.save && receiving_artist.save
      @share_request.update(status: 'accepted')
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
  
  def destroy
    if @share_request.destroy
      render json: "Request deleted successfully!"
    else
      render json: "Failed to delete!"
    end
  end
  
  private
  
  
  def find_request
    begin
      @share_request = ShareRequest.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No share request found for given id."}, status: :unprocessable_entity 
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
    params.permit(:price, :request_percentage)
  end
  
  def validate_artist
    if @current_user.user_type != 'Artist'
      render json: { error: 'Listener are Not Allowed for this request' }, status: :forbidden
    end
  end 
  
end
