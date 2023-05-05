class RequestsController < ApplicationController
      def index
        begin
            @requests = Request.all
            render json: @requests
        rescue => e 
            render json: {error: 'Internal Server Error'}, status: :internal_server_error      
        end
      end
    
      def show
        begin
            @request = Request.find(params[:id])
            render json: @request
        rescue ActiveRecord::RecordNotFound => e
            render json: {error: 'Record Not Found'}, status: :not_found
        rescue => e
            render json: {error: 'Internal Server Error'}, status: :internal_server_error
        end
      end
    
      def create
        begin
            @request = Request.new(request_params)
            if @request.save 
                render json: @request, status: :created 
            else 
                render json: @request.errors, status: :unprocessable_entity
            end 
        rescue => exception
            render json: {error: 'Internal Server Error'}, status: :internal_server_error           
        end
      end
    
      def update
        @request = Request.find(params[:id])
        if @request.update(request_params)
            render json: @request, status: :ok 
        else 
            render json: @request.errors, status: :unprocessable_entity
        end
      end
    
      def destroy
        begin
            @request= Request.find(params[:id])
            if @request.destroy 
               render json: {message: 'Request Destroyed Successfully'}, status: :ok
            else 
                render json: @user.errors, status: :unprocessable_entity
            end 
        rescue ActiveRecord::RecordNotFound => e
            render json: {error: 'Record Not Found'}, status: :not_found
        rescue => e 
            render json: {error: 'Internal Server Error'}, status: :internal_server_error
        end
      end

      private 
        def request_params 
            params.require(:request).permit(:user_id,:task_type,:description,:latitude,:longitude,:status)
        end 

end
