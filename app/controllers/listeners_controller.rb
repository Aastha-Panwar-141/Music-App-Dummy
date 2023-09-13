class ListenersController < ApplicationController
    skip_before_action :authenticate_request, only: [:create]
  before_action :set_listener, only: [:show, :destroy, :update]

  # GET /listeners
  def index
    listeners = Listener.all
    render json: listeners, status: :ok
  end

  # GET /listeners/{listenername}
  def show
    render json: @listener, status: :ok
  end

  # POST /listeners
  def create
    listener = Listener.new(listener_params)
    if listener.save
      render json: listener, status: :created
    else
      render json: { errors: listener.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /listeners/{listenername}
  def update
    unless @listener.update(listener_params)
      render json: { errors: @listener.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /listeners/{listenername}
  def destroy
    @listener.destroy
  end

  private

  def set_listener
    @listener = Listener.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'listener not found' }, status: :not_found
  end

  def listener_params
    params.permit(
      :listenername, :email, :password
    )
  end
end
