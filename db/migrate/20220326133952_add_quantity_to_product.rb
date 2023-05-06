class AddQuantityToProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :quantity, :integer, default: 0
    add_column :orders, :comment, :string
  end
end
