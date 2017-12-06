class SessionsController < ApplicationController
    before_action :already_authenticated?, only: [:new]

    def create
        @user = User.find_by(email: params[:email])

        if authenticated
            session[:user_id] = @user.id
            flash[:success] = 'Successfully logged in.'
            redirect_to users_path
        else
            flash.now[:error] = 'Invalid credentials.'
            render :new
        end
    end

    def destroy
        session[:user_id] = nil if current_user
        redirect_to users_path
    end

    private

    def authenticated
        @user && @user.authenticate(params[:password])
    end

    def already_authenticated?
        redirect_to user_path(current_user) if current_user
    end
end