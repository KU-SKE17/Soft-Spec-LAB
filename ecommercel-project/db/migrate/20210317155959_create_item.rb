class CreateItem < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.text :title
      t.text :description
      t.integer :stock
      t.float :price
      t.text :tags

      t.timestamps
    end
  end
end
