class AddStatusToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :status, :integer, :default => 0
    change_column :products, :status, :integer, :default => 0
  end
end
