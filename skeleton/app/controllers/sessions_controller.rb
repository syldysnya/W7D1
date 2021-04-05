class SessionsController < ApplicationController

    def new
        render :new
    end

    def create
        @user = User.find_by_credentials(
            params[:user][:user_name],
            params[:user][:password]
        )

        if @user
            login!(@user)
            redirect_to cats_url
        else
            render :new
        end
    end

    def destroy
    #     @user = User.find_by_credentials(
    #         params[:user][:user_name],
    #         params[:user][:password]
    #     )

    #     @user.destroy
    #     redirect_to users_url

        @user = current_user
        @user.reset_session_token! if @user != nil
        session[:session_token] = nil
        redirect_to cats_url
    end
end