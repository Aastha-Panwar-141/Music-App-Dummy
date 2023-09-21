class UserMailer < ApplicationMailer
    
    default from: 'asthap@shriffle.com'
    
    # def welcome_email
    #     @user = params[:user]
    #     @url  = 'http://example.com/login'
    #     mail(to: @user.email, subject: 'Welcome to My Awesome Site')
    # end
    
    def token_email
        @user=params[:user]
        mail(to: @user.email, subject: "Token Email")
    end
    
    def welcome_email
        @user=params[:user]
        mail(to: @user.email, subject: "Welcome to Music App")
    end
    
end
