class PasswordMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.password_mailer.reset.subject
  #

  #by default generated method
  # def reset
  #   @greeting = "Hi"

  #   mail to: "to@example.org"
  # end

  def reset
    @user = params[:user]
    
    @token = @user.signed_id(purpose: 'password_reset', expires_in: 15.minutes)
    
    mail to: @user.email_address
  end
  
end
