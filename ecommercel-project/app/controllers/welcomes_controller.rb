class WelcomesController < ApplicationController
    def index
        @search = params[:search]
        @items = Item.where(status: :published)
        @items = @items.search(@search) if @search.present?
        @items = @items.page(params[:page]).per(24)
    end

    def show
        @item = Item.find(params[:id])
    end
end
