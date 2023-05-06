class AddFieldsToOrdersProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :orders_products, :color, :string
    add_column :orders_products, :size, :string
    add_column :orders_products, :price, :float
  end
end
