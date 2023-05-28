# class RepublishAlertJob
#   include Sidekiq::Job

#   def perform(request_id)
#     request = Request.find_by(id: request_id)
#     return unless request && request.closed && request.status == "Unfilled"&& request.last_response_at < 24.hours.ago && request.user_counter >= 5
    
#     ActionCable.server.broadcast("notifications_#{request.user_id}",message:"You can republish your request")
#   end
# end
