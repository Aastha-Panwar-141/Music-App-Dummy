class ShareRequestsController < ApplicationController
  before_action :validate_artist
  before_action :find_request, only: [:accept, :reject]
  before_action :check_owner, only: [:accept, :reject]
  
  
  
  def index
    share_requests = ShareRequest.all 
    render json: share_requests
  end
  
  def create
    # byebug
    share_request = ShareRequest.new(
      requesting_artist: @current_user,
      receiving_artist: User.find(params[:receiver_id]),
      requested_percent: params[:requested_percent],
      status: 'pending'
    )
    if share_request.save
      render json: "Request sent successfully!", status: :created
    else
      render json: {error: share_request.errors.full_messages}, status: :unprocessable_entity
    end
  end
  
  # def accept
  #   byebug
  #   if @share_request.status == 'pending'
  #     receiving_artist = @share_request.receiving_artist
  #     receiving_artist.update(requested_percent: @share_request.requested_percent)
  #     @share_request.update(status: 'accepted')
  #     render json: { message: 'Share request accepted' }
  #   else
  #     render json: { error: 'Share request has already been processed' }, status: :unprocessable_entity
  #   end
  # end
  
  
  
  def reject
  end
  
  
  private
  
  def find_request
    # byebug
    begin
      @share_request = ShareRequest.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No record found for given id."} 
    end
  end
  
  def check_owner
    begin
      @share_request.receiver_id == @current_user.id
    rescue ActiveRecord::RecordNotFound
      render json: {result: "No record found for given id."} 
    end
  end
  def share_params
    params.permit(:receiver_id, :requested_percent)
  end
  
  def validate_artist
    if @current_user.user_type != 'Artist'
      render json: { error: 'Listener are Not Allowed for this request' }, status: :forbidden
    end
  end 
  
end
