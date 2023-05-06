class AddDefaultValueToBrands < ActiveRecord::Migration[6.1]
  def change
    change_column :products, :img, :string, :default => 'no-image.jpg'
  end
end
