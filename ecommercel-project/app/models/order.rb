class Order < ApplicationRecord
    enum status: { awaiting_payment: 0, awaiting_shipment: 1, completed: 2, cancelled: 3 }

    scope :search, -> (keyword) { where("order_id like ? or status like ?", "%#{keyword}%", "%#{keyword}%") }

    belongs_to :user
    belongs_to :item

    validates :amount, :numericality => { :greater_than_or_equal_to => 0 }
    validate :possible_amount


    def possible_amount
        if amount > item.stock
            errors.add(:amount, "must not over item stock")
        end
    end
end
