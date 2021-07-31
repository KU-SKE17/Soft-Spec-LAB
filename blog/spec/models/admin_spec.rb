require 'rails_helper'

RSpec.describe Admin, type: :model do

  describe "say_hello" do
    it "return string 'Hello'" do
      admin = Admin.new
      expect(admin.say_hello).to eq('Hello')
    end
  end

  describe "admin email cannot contain a word 'bob'" do
    context "emails contains bob" do
      it "is invalid to have bob in email" do
        admin = Admin.new(email: 'bob@gmail.com', password: '111111')
        expect(admin.valid?).to eq(false)
      end
    end

    context "emails does not contain bob" do
      it "is valid not to have bob in email" do
        admin = Admin.new(email: 'beb@gmail.com', password: '111111')
        expect(admin.valid?).to eq(true)
      end
    end
  end

end
