# class ConversationChannel < ApplicationCable::Channel
#   def subscribed
#     # stream_from "some_channel"
#     stream_from "conversations_#{current_user.id}_#{params[:conversation_id]}"
#   end

#   def unsubscribed
#     # Any cleanup needed when channel is unsubscribed
#   end
# end
