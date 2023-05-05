class AuthentificationController < ApplicationController
    skip_before_action :authorize_request, only: :create 
    def create
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            render json: {token: token}, status: :created 
        else  
            render json: {error: 'Invalid Credentials'}, status: :unauthorized
        end 
    end 
end
