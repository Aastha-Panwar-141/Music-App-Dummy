class UserMailer < ApplicationMailer
    
    default from: 'asthap@shriffle.com'
    
    # def welcome_email
    #     @user = params[:user]
    #     @url  = 'http://example.com/login'
    #     mail(to: @user.email, subject: 'Welcome to My Awesome Site')
    # end
    
    # def welcome_email(user)
    #     @user = user
    #     mail(to: @user.email, subject: 'Welcome to My Awesome Site')
    # end  
    
    def welcome_email
        @user=params[:user]
        mail(to: @user.email, subject: "Token Email")
      end
    
end
