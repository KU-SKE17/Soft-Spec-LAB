class User < ApplicationRecord

    scope :search , -> (keyword) { where("username like ? or email like ? or role like ?", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%") }
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable

    has_many :orders
    has_many :comments

    before_destroy :cancel_orders

    def cancel_orders
        self.orders.map { |order| order.status = 3; order.save}
    end
end
