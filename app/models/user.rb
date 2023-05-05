class User < ApplicationRecord

    has_secure_password

    has_many :requests 
    has_many :messages 
    has_many :conversations, through: :conversation_users

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true 
    validates :password, presence: true, length: {minimum: 6}, on: :create

end
