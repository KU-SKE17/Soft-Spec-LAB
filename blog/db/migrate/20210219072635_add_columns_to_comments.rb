class AddColumnsToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :author, :string
    add_column :comments, :text, :string
  end
end
