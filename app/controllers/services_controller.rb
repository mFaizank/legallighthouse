class ServicesController < ApplicationController
  before_action :authenticate_lawyer!
  layout 'profile', only: :index

  def index
    @lawyer = current_lawyer
    @areas = @lawyer.areas
  end

  def new
    load_lawyer
    @area = Area.find(params[:id])
    @service = @lawyer.services.new(specialization: @area.name)
  end

  def create
    load_lawyer
    @service = @lawyer.services.new(service_params)

    if @service.save
      flash[:notice] = "Service #{@service.name} added."
      area = @lawyer.areas.find_by(name: service_params[:specialization])
      redirect_to new_service_path(area)
    else
      render :new
    end
  end

  def edit
    load_lawyer
    load_service
  end

  def update
    load_lawyer
    load_service
    
    if @service.update(service_params)
      redirect_to services_path
    else
      render :edit
    end
  end

  def destroy
    load_service
    @service.destroy

    redirect_to services_path
  end

  private

  def load_lawyer
    @lawyer = current_lawyer
  end

  def load_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:specialization, :name, :description,
      :fixed_fee, :case_specific, :starting_at)
  end
end
