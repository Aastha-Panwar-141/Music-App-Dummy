class ApplicationController < ActionController::API
 include JsonWebToken

 before_action :authenticate_request

  def not_found
    render json: { error: 'not_found' }
  end

  private
  #this function has responsibility for authorizing user requests
  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(' ').last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end
end