class UsersController < ApplicationController
    before_action :find_user, only: [:edit, :update, :destroy]
    before_action :unauthenticated?, only: [:edit, :update, :destroy]

    def index
        @users = User.top_ten_by_score
    end

    def new
        if current_user
            redirect_to user_path current_user
        else
            @user = User.new
        end
    end

    def show
        if current_user
            if params[:id].to_i == current_user
                redirect_to edit_user_path params[:id]
            else
                user = User.find_by(id: params[:id])
                render :show, locals: { user: user } if user
            end
        else
            redirect_to login_path
        end
    end

    def create
        @user = User.new(create_user_params)

        if @user.save
            redirect_to login_path
        else
            render :new
        end
    end

    def edit
        if current_user == @user.id
            render :edit
        else
            redirect_to user_path current_user
        end
    end

    def update
        if @user.update(update_user_params)
            flash[:success] = 'Success.'
            redirect_to user_path @user
        else
            flash.now[:error] = 'Invalid input.'
            render :edit
        end
    end

    def destroy
        if @user.id == current_user
            session[:user_id] = nil
            @user.destroy
        end

        redirect_to users_path
    end

    private

    def create_user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password)
    end

    def update_user_params
        params.require(:user).permit(:first_name, :last_name, :password)
    end

    def find_user
        @user ||= User.find_by(id: params[:id])
    end
end