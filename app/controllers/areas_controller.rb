class AreasController < ApplicationController
  before_action :authenticate_lawyer!

  def new
    lawyer = current_lawyer
    @area = lawyer.areas.new
    @areas = lawyer.areas.select(&:id)
  end

  def create
    lawyer = current_lawyer
    @area = lawyer.areas.new(area_params)

    if @area.save
      redirect_to(new_area_path)
    else
      @areas = lawyer.areas.select(&:id)
      render :new
    end
  end

  def edit
    load_area
  end

  def update
    load_area
    @area.update!(area_params)
    redirect_to(new_area_path)
  end

  def destroy
    load_area
    @area.destroy
    redirect_to(new_area_path)
  end

  private

  def load_area
    @area = Area.find(params[:id])
  end

  def area_params
    params.require(:area).permit(:name)
  end
end
