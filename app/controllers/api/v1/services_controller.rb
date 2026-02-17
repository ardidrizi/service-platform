module Api
  module V1
    class ServicesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_service, only: %i[show update destroy]

      after_action :verify_policy_scoped, only: :index
      after_action :verify_authorized, except: :index

      def index
        @services = policy_scope(Service)
        render json: @services
      end

      def show
        authorize(@service)
        render json: @service
      end

      def create
        @service = current_user.services.build(service_params)
        authorize(@service)

        if @service.save
          render json: @service, status: :created
        else
          render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize(@service)

        if @service.update(service_params)
          render json: @service
        else
          render json: { errors: @service.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize(@service)
        @service.destroy
        head :no_content
      end

      private

      def set_service
        @service = Service.find(params[:id])
      end

      def service_params
        params.require(:service).permit(:title, :description, :price)
      end
    end
  end
end
