class AddDefaultValueToProducts < ActiveRecord::Migration[6.1]
  def change
    change_column :brands, :img, :string, :default => 'no-image.jpg'
  end
end
