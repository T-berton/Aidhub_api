class ConversationsController < ApplicationController

      def index
        @requester = @current_user
        begin
            if params[:my_conversations].present?
            @conversations = @current_user.conversations
            # @other_user= ConversationUser.joins(:user).where.not(user_id:)
            render json: @conversations.as_json(include: { request: { include: { user: { only: [:first_name, :last_name] }}}, conversation_users: {include: {user:{only: [:first_name,:last_name,:id]}}}})
          end
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
        begin
          request = Request.find(params[:conversation][:request_id])
          @responder = @current_user
          if request.closed
            render json: { error: "This request is closed and cannot accept new conversations." }, status: :unprocessable_entity
            return
          end
          ActiveRecord::Base.transaction do  #permet de faire une transaction sécurisé avec la BDD, si il y a une erreur, rien ne passe
            @conversation = Conversation.new(conversation_params)
            if @conversation.save
                ConversationUser.create!(user_id: @responder.id,conversation_id: @conversation.id)
                ConversationUser.create!(user_id: params[:requester_id],conversation_id: @conversation.id)
                @conversation.request.increment!(:user_counter)
                if @conversation.request.user_counter>=5 
                  @conversation.request.update!(closed: true)
                end 
                render json: @conversation, status: :created
            else  
                render json: @conversation.errors, status: :unprocessable_entity
            end
          end 
        rescue => e  
          render json: {error: e.message}, status: :internal_server_error          
        end
      end
    
      def destroy
        begin
          @conversation = Conversation.find(params[:id])
          current_user = User.find_by(id: params[:user_id])
          requester_id = @conversation.request.user_id
          if current_user.id == requester_id 
            if @conversation.request.destroy
              puts "Successfully destroyed the request and the conversation"
              render json: {message: "Request And Conversation Deleted Successfully"}, status: :ok 
            else
              puts "Failed to destroy the request and the conversation"
              render json: @conversation.errors, status: :unprocessable_entity
            end
          else
            if @conversation.destroy  
              puts "Successfully destroyed the conversation"
              @conversation.request.decrement!(:user_counter)
              if @conversation.request.user_counter<5 
                @conversation.request.update!(closed: false)
              end 
              render json: {message: "Conversation Deleted Successfully"}, status: :ok 
            else
              puts "Failed to destroy the conversation"
              render json: @conversation.errors, status: :unprocessable_entity
            end
          end 
        rescue => e  
          puts "Error occurred during destroy action: #{e.message}"
          render json: {error: e.message}, status: :internal_server_error
        end
      end
      

      private 
        def conversation_params 
            params.require(:conversation).permit(:request_id,:last_response_at)
        end 
end
