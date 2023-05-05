class MessagesController < ApplicationController
    def index
        begin
            @messages = Message.all
            render json: @messages
        rescue => e  
            render json: {error: e.message}, status: :internal_server_error
        end
    end
    
    def show
        begin
            @message = Message.find(params[:id])
            render json: @message 
        rescue ActiveRecord::RecordNotFound => e 
            render json: {error: e.message}, status: :not_found 
        rescue => e 
            render json: {error: e.message}, status: :internal_server_error
        end
    end
    
    def create
        begin
            @message = Message.new(message_params)
            if @message.save
                render json: @message, status: :created
            else  
                render json: @message.errors, status: :unprocessable_entity
            end 
        rescue => e 
            render json: {error: e.message}, status: :internal_server_error
        end
    end
    
    def update
        @message = Message.find(params[:id])
        if @message.update(message_params)
            render json: @message, status: :accepted
        else 
            render json: @message.errors, status: :internal_server_error
        end
    end 
    
    def destroy
        begin
            @message= Message.find(params[:id])
            if @message.destroy
                render json: {message: "Message Deleted Successfully"}, status: :ok
            else 
                render json: @message.errors,status: :unprocessable_entity
            end 
        rescue =>e 
            render json: {error: e.message}, status: :internal_server_error
        end 
    end

      private 
        def message_params
            if action_name == 'update'
                params.require(:message).permit(:content)
            else 
                params.require(:message).permit(:user_id,:conversation_id,:content)
            end
        end
end
