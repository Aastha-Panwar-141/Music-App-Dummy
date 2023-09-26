class UserMailer < ApplicationMailer
    
    default from: 'asthap@shriffle.com'
    
    def token_email
        @user=params[:user]
        mail(to: @user.email, subject: "Token Email")
    end
    
    def welcome_email
        @user=params[:user]
        mail(to: @user.email, subject: "Welcome to Music App")
    end
    
end
