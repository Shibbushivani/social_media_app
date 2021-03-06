# User
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthabl  
  include Uploadable
  has_many :posts, dependent: :destroy
  has_many :comments
  has_many :likes
  has_many :notifications, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true, case_sensitive: false
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
