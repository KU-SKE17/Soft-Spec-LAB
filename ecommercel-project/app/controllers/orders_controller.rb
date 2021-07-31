class OrdersController < ApplicationController
    before_action :authenticate_user!

    def index
        @search = params[:search]
        @orders = Order.all
        @orders = @orders.search(@search) if @search.present?
        @orders = @orders.page(params[:page]).per(10)
    end

    def new
        @order = Order.new
    end

    def edit
        @order = Order.find(params[:id])
    end

    def create
        @order = Order.create(order_params)
        if @order.invalid?
            flash[:error] = @order.errors.full_messages
        end
        redirect_to action: :index
    end

    def update
        @order = Order.find(params[:id])
        @order.update(order_params)
        redirect_to action: :index
    end

    def destroy
        @order = Order.find(params[:id])
        @order.destroy
        redirect_to action: :index
    end

    private

    def order_params
        params.require(:order).permit(:status, :item_id, :user_id,  :amount, :note)
    end
end
