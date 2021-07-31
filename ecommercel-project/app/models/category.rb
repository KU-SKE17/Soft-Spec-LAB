class Category < ApplicationRecord

    scope :search , -> (keyword) { where("name like ?", "%#{keyword}%") }

    has_many :item_categories, dependent: :destroy
    has_many :items, through: :item_categories
end
