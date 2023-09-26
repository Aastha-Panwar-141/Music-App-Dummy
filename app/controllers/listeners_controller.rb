class ListenersController < ApplicationController
  # # skip_before_action :authenticate_request, only: [:create]
  # before_action :authenticate_request, except: [:index, :create]

  # before_action :set_listener, only: [:show, :destroy, :update]
  
  # # GET /listeners
  # def index
  #   listeners = Listener.all
  #   render json: listeners, status: :ok
  # end
  
  # # GET /listeners/{listenername}
  # def show
  #   render json: @current_user
  # end
  
  # # POST /listeners
  # def create
  #   listener = Listener.new(listener_params)
  #   if listener.save
  #     render json: {message: 'Listener created!', created_record: listener}, status: :created
  #   else
  #     render json: { errors: listener.errors.full_messages },
  #     status: :unprocessable_entity
  #   end
  # end
  
  # # PUT /listeners/{listenername}
  # def update
  #   if @current_user.update(listener_params)
  #     render json: {message: 'Listener updated', updated_record: @current_user}
  #   else
  #     render json: {errors: @current_user.errors}, status: :unprocessable_entity
  #   end
  #   # unless @listener.update(listener_params)
  #   #   render json: { errors: @listener.errors.full_messages },
  #   #          status: :unprocessable_entity
  #   # end
  # end
  
  # # DELETE /listeners/{listenername}
  # def destroy
  #   if @current_user.destroy
  #     render json: { message: 'Listener deleted', deleted_record: @current_user }
  #   else
  #     render json: { message: 'Listener deletion failed' }
  #   end
  # end
  
  # private
  
  # # def set_listener
  # #   @listener = Listener.find(params[:id])
  # # rescue ActiveRecord::RecordNotFound
  # #   render json: { errors: 'listener not found' }, status: :not_found
  # # end
  
  # def listener_params
  #   params.permit(
  #     :username, :email, :password
  #   )
  # end
end

