class Category < ApplicationRecord
  has_ancestry
  has_many :products

  validates :title, presence: true
  validates :bytitle, presence: true
end
