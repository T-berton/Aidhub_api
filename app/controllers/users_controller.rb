class UsersController < ApplicationController

    skip_before_action :authorize_request, only: [:create]

    def index
        begin
            @users=User.all
            render json: @users
        rescue => e
            render json: {error: 'Internal Server Error'}, status: :internal_server_error
        end
    end 

    def show
        begin
            @user = User.find(params[:id])
            render json: @user
        rescue ActiveRecord::RecordNotFound => e
            render json: {error: 'Record Not Found'}, status: :not_found 
        rescue => e
            render json: {error: 'Internal Server Error'}, status: :internal_server_error
        end
    end

    def create 
        @user = User.new(user_params)
        if @user.save 
            token = JsonWebToken.encode(user_id: @user.id)
            render json: {user: @user, token: token}, status: :created
        else 
            render json: @user.errors, status: :unprocessable_entity
        end 
    end 

    def update 
        begin
            @user = User.find(params[:id])
            if @user.update(user_params)
                render json: @user, status: :accepted
            else 
                render json: @user.errors, status: :unprocessable_entity
            end
        rescue => e
            render json: {error: 'Internal Server Error'}, status: :internal_server_error
        end
    end 

    def destroy 
        begin
            @user = User.find(params[:id])
            if @user.destroy
                render json: {message: 'User Deleted Successfully'}, status: :ok 
            else 
                render json: @user.errors, status: :unprocessable_entity
            end 
        rescue ActiveRecord::RecordNotFound => e 
            render json: {error: 'Record Not Found'}, status: :not_found
        rescue => e 
            render json: {error: 'Internal Server Error'},status: :internal_server_error
        end  
    end 

    private 
        def user_params
            params.require(:user).permit(:first_name,:last_name,:email,:password,:government_file)
        end 
    

end
