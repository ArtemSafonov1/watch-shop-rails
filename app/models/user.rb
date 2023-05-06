class User < ApplicationRecord
  include UserOath

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook]
  
  has_one :cart, dependent: :destroy
  has_many :authorizations
  has_many :orders

  validates :first_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }, length: {minimum: 3}
  validates :last_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }, length: {minimum: 3}
  validates :country, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }, length: {minimum: 3}
  validates :address, presence: true, length: {minimum: 3}
  validates :phone, presence: true, :numericality => true, :length => { :minimum => 10, :maximum => 15 }
  validates :email, presence: true
  validates :password, presence: true, length: {minimum: 6, maximum: 120}, on: :create
end
