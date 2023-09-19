class PasswordMailer < ApplicationMailer
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome')
  end
  def forget_mailer(user)
    @user = user
    mail(to: @user.email, subject: 'Forget')
  end
  def reset_mailer(user)
    @user = user
    mail(to: @user.email, subject: 'Reset')
  end
  
  # def reset
  #   @user = params[:user]
    
  #   @token = @user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)
    
  #   mail to: @user.email
  # end
  
  # def token_email
  #   @user=params[:user]
  #   mail(to: @user.email, subject: "Token Email")
  # end
  
end
