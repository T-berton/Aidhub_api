class ConversationsController < ApplicationController

      def index
        begin
            @conversations = Conversation.all
            render json: @conversations  
        rescue => e  
            render json: {error: e.message}, status: :internal_server_error
        end
      end
    
      def show
        begin
            @conversation = Conversation.find(params[:id])
            render json: @conversation            
        rescue => e  
            render json: {error: e.message}, status: :internal_server_error
        end
      end
    
      def create
        @conversation = Conversation.new(conversation_params)
        if @conversation.save
            render json: @conversation, status: :created
        else  
            render json: @conversation.errors, status: :unprocessable_entity
        end
      end
    
      def destroy
        begin
            puts "caca"
          @conversation = Conversation.find(params[:id])
          if @conversation.destroy
            puts "Successfully destroyed the conversation"
            render json: {message: "Conversation Deleted Successfully"}, status: :ok 
          else
            puts "Failed to destroy the conversation"
            render json: @conversation.errors, status: :unprocessable_entity
          end
        rescue => e  
          puts "Error occurred during destroy action: #{e.message}"
          render json: {error: e.message}, status: :internal_server_error
        end
      end
      

      private 
        def conversation_params 
            params.require(:conversation).permit(:request_id)
        end 
end
