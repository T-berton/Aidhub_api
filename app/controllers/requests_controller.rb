class RequestsController < ApplicationController


      def index
        @requester = @current_user   # Associe l'utilisateur courant à la demande
        begin
            if params[:task_type].present?
                @requests = Request.where(task_type: params[:task_type])
            elsif params[:latitude].present? && params[:longitude].present?
                requester_response_ids = ConversationUser.joins(:conversation).where(user_id: @requester.id).pluck('conversations.request_id')
                puts "Latitude: #{params[:latitude]}, Longitude: #{params[:longitude]}"
                puts "Total requests: #{Request.count}"
                # @request_filter = Request.where.not(latitude: nil, longitude: nil,closed: true,user_id: @requester.id)
                @request_filter = Request.where.not(latitude: nil)
                .where.not(longitude: nil)
                .where.not(closed: true)
                .where.not(user_id: @requester.id)
                .where.not(id: requester_response_ids)
                puts "Filtered requests: #{@request_filter.count}"
                puts "Requester ID #{@requester.id}"
                @requests = @request_filter.within(10, :origin => [params[:latitude],params[:longitude]]).all
            elsif params[:my_requests].present?
                @requests = Request.where(user_id: @requester.id)
            else
                @requests = Request.all
            end 
            render json: @requests
        rescue => e 
            Rails.logger.error "Internal Server Error : #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
            render json: {error: "Internal Server Error : #{e.message}, backtrace: #{e.backtrace}"}, status: :internal_server_error
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
            @request.user_id = @current_user.id   # Associe l'utilisateur courant à la demande

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
        if request_params[:status] == 'Success'
            if @request.destroy
                render json: {message: 'Request marked as Success and destroyed'}, status: :ok
            else
                render json: @request.errors, status: :unprocessable_entity
            end
        else
            if @request.update(request_params)
                render json: @request, status: :ok 
            else 
                render json: @request.errors, status: :unprocessable_entity
            end 
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
            params.require(:request).permit(:title,:task_type,:description,:latitude,:longitude,:status)
        end 

end
