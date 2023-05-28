# class NotificationsChannel < ApplicationCable::Channel
#   def subscribed
#     # stream_from "some_channel"
#     stream_from "notifications_#{current_user.id}_#{params[:request_id]}"
#   end

# end
