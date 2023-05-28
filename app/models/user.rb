class User < ApplicationRecord

    has_secure_password
    has_one_attached :government_file

    has_many :requests,dependent: :destroy
    has_many :messages, dependent: :destroy
    has_many :conversation_users, dependent: :destroy
    has_many :conversations, through: :conversation_users

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true 
    validates :password, presence: true, length: {minimum: 6}, on: :create

end
