class Conversation < ApplicationRecord
    belongs_to :request 
    has_many :users, through: :conversation_users
end
