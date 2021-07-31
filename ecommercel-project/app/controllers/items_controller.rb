class ItemsController < ApplicationController
    before_action :authenticate_user!

    def index
        @search = params[:search]
        @items = Item.all
        @items = @items.search(@search) if @search.present?
        @items = @items.page(params[:page]).order({ updated_at: :desc }).per(10)

        respond_to do |format|
            format.html
            format.csv { send_data generate_csv(Item.all), file_name: 'items.csv' }
        end
    end

    def show
        @item = Item.find(params[:id])
    end

    def new
        @item = Item.new
    end

    def edit
        @item = Item.find(params[:id])
    end

    def create
        @item = Item.create(item_params)

        if @item.invalid?
            flash[:error] = @item.errors.full_messages
        end

        redirect_to action: :index
    end

    def update
        @item = Item.find(params[:id])
        @item.update(item_params)
        redirect_to action: :index
    end

    def destroy
        @item = Item.find(params[:id])
        @item.destroy
        redirect_to action: :index
    end

    def csv_upload
        data = params[:csv_file].read.split("\n")
        data.each do |line|
            attr = line.split(",").map(&:strip)
            Item.create title: attr[0], description: attr[1], stock: attr[2], price: attr[3]
        end
        redirect_to action: :index
    end

    def del_main_image
        @item = Item.find(params[:id])
        @item.delete_primary_image
        redirect_to action: :index
    end

    def del_support_images
        @item = Item.find(params[:id])
        @item.delete_supporting_images
        redirect_to action: :index
    end

    private

    def item_params
        params.require(:item).permit(:status, :primary_image, :title, :description, :stock, :price, :tags, category_ids: [], supporting_images: [])
    end

    def generate_csv(items)
        items.map { |a| [a.title, a.description, a.stock, a.price, a.created_at.to_date].join(',') }.join("\n")
    end
end
