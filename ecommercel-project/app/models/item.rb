class Item < ApplicationRecord
    enum status: { draft: 0, published: 1, archived: 2 }

    scope :search, -> (keyword) { where("title like ? or description like ? or tags like ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%") }

    has_many :item_categories, dependent: :destroy
    has_many :categories, through: :item_categories
    has_many :orders
    has_many :comments

    has_one_attached :primary_image
    has_many_attached :supporting_images

    validates :title, length: { minimum: 4 }
    validates :description, length: { minimum: 4 }
    validates :stock, :numericality => { :greater_than_or_equal_to => 0 }
    validates :price, :numericality => { :greater_than_or_equal_to => 0 }

    before_destroy :delete_primary_image, :delete_supporting_images, :cancel_orders

    def delete_primary_image
        self.primary_image.purge
    end

    def delete_supporting_images
        self.supporting_images.purge
    end

    def cancel_orders
        self.orders.map { |order| order.status = 3; order.save}
    end
end
