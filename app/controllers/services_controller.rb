class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: %i[show edit update destroy]

  after_action :verify_policy_scoped, only: :index
  after_action :verify_authorized, except: :index

  def index
    @services = policy_scope(Service)
  end

  def show
    authorize(@service)
  end

  def new
    @service = current_user.services.build
    authorize(@service)
  end

  def create
    @service = current_user.services.build(service_params)
    authorize(@service)

    if @service.save
      redirect_to @service, notice: "Service created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize(@service)
  end

  def update
    authorize(@service)

    if @service.update(service_params)
      redirect_to @service, notice: "Service updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize(@service)
    @service.destroy
    redirect_to services_path, notice: "Service deleted."
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:title, :description, :price)
  end
end
