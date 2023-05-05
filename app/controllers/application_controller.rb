class ApplicationController < ActionController::API
    before_action :authorize_request
  
  private 
    def authorize_request
      header = request.headers['Authorization']
      if header 
        token = header.split(' ').last
      else
        render json: { error: "Missing token" }, status: :unauthorized
      return
      end 
      begin
        token_decoded = JsonWebToken.decode(token)
        puts "Token decoded: #{token_decoded}"
        user_id = token_decoded[:user_id]
        puts "User ID: #{user_id}"
        @current_user = User.find(user_id)
        rescue ActiveRecord::RecordNotFound => e
          render json: { error: e.message }, status: :not_found
        rescue JWT::DecodeError => e
          render json: { error: "Invalid token" }, status: :unauthorized
        rescue => e 
          render json: { error: e.message }, status: :internal_server_error
      end
    end


end   