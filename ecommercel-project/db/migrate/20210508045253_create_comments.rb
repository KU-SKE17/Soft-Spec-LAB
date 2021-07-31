class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.belongs_to :item
      t.belongs_to :user
      t.string :author
      t.string :text
      t.timestamps
    end
  end
end
