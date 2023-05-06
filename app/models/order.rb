class Order < ApplicationRecord
  belongs_to :user
  has_many :orders_products, dependent: :destroy
  has_many :products, through: :orders_products
  
  enum status: {"New": 0, "In Progress": 2, "Queue": 1, "Completed": 3, "Provided": 4, "Canselled": 5}
end
