class Product < ApplicationRecord
  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }
  validates :old_price, numericality: { greater_than: 0, less_than: 1000 }, allow_blank: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  has_many :orders_products
  has_many :related_products
  has_many :related, through: :related_products
  has_many :galleries
  belongs_to :category
  belongs_to :brand
  
  enum hit: {hit: 1, not_hit: 0}
  enum status: {active: 1, not_active: 0}

  #scope :active, ~> {where(status: 1)}
end
