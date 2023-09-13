require "jwt"
module JsonWebToken
  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secrets.secret_key_base
  
  def jwt_encode(payload, exp = 7.days.from_now)  #default exp - 24 hours
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
  
  #decoded the token given by the user and get the first value then assign it to a decoded variable
  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
