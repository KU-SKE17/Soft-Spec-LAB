class CategoriesController < ApplicationController
    before_action :authenticate_user!

    def index
        @search = params[:search]
        @categories = Category.all
        @categories = @categories.search(@search) if @search.present?
        @categories = @categories.page(params[:page]).per(10)
    end

    def show
        @category = Category.find(params[:id])
    end

    def new
        @category = Category.new
    end

    def edit
        @category = Category.find(params[:id])
    end

    def create
        @category = Category.create(category_params)
        if @category.invalid?
            flash[:error] = @category.errors.full_messages
        end
        redirect_to action: :index
    end

    def update
        @category = Category.find(params[:id])
        @category.update(category_params)
        redirect_to action: :index
    end

    def destroy
        @category = Category.find(params[:id])
        @category.destroy
        redirect_to action: :index
    end

    private

    def category_params
        params.require(:category).permit(:name)
    end

end
