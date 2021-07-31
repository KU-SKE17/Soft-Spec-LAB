class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :email_cannot_have_bob

  def email_cannot_have_bob
    # errors.add(:email, :email_cannot_have_bob) if email.downcase.include?('bob')
    if email.downcase.include?('bob')
      errors.add(:email, 'cannot contain bob')
    end
  end

  def say_hello
    'Hello' # return 'hello'
  end
end
