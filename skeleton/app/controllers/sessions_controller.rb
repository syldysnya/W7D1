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
            redirect_to user_url(@user)
        else
            render :new
        end
    end

    def destroy
        @user = User.find_by_credentials(
            params[:user][:user_name],
            params[:user][:password]
        )

        @user.destroy
        redirect_to users_url
    end
end