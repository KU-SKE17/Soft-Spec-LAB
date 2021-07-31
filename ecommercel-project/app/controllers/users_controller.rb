class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        @search = params[:search]
        @users = User.all
        @users = @users.search(@search) if @search.present?
        @users = @users.page(params[:page]).order(email: :asc).per(10)
    end

    def switch_role
        @user = User.find(params[:id])
        if @user.role == "Admin"
            @user.role = "Customer"
        else
            @user.role = "Admin"
        end
        @user.save
        redirect_to action: :index
    end

    def destroy
        @user = User.find(params[:id])
        @user.destroy
        redirect_to action: :index
    end
end
