class Conversation < ApplicationRecord
    belongs_to :request 
    has_many :users, through: :conversation_users
    has_many :messages, dependent: :destroy
    has_many :conversation_users, dependent: :destroy
end
