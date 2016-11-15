class LawyersController < ApplicationController
  before_action :authenticate_lawyer!, only: [:edit, :update]
  layout 'profile', only: :edit

  def index
    @lawyers = Lawyer.all

    unless lawyer_params[:search_law_type].blank?
      @lawyers = @lawyers.where('? = ANY(specializations)', lawyer_params[:search_law_type].downcase)
    end

    unless lawyer_params[:search_language].blank?
      @lawyers = @lawyers.where('? = ANY(languages)', lawyer_params[:search_language].downcase)
    end

    unless lawyer_params[:search_individual].blank?
      @lawyers = @lawyers.where(lawyer_params[:search_individual].downcase => true)
    end

    @lawyers = @lawyers.where(fixed_fees: true) if lawyer_params[:search_fixed_fees] == '1'
    @lawyers = @lawyers.where(unbundling: true) if lawyer_params[:search_unbundling] == '1'

    unless lawyer_params[:search_name].blank?
      names = lawyer_params[:search_name].downcase.split /\s+/
      @lawyers = @lawyers.where('LOWER(first_name) IN (?) OR LOWER(last_name) IN (?)', names, names)
    end
  end

  def show
    @lawyer = Lawyer.find(params[:id])

    unless @lawyer.listed?
      redirect_to(root_path, notice: 'This profile is not currently listed')
    end
  end

  def public_show
    @lawyer = Lawyer.find_by(public_id: params[:public_id])

    if @lawyer.listed?
      render :show
    else
      redirect_to(root_path, notice: 'This profile is not currently listed')
    end
  end

  def preview
    @hard_language = true
    @lawyer = current_lawyer
    render :show
  end

  def edit
    @lawyer = current_lawyer
  end

  def update
    @lawyer = current_lawyer

    if current_lawyer.update(lawyer_params)
      if !current_lawyer.profile.complete? && current_lawyer.listed?
        current_lawyer.profile.unlist!
      end

      flash[:notice] = "Profile saved."
      redirect_to(edit_profile_path)
    else
      render :edit
    end
  end

  def list
    current_lawyer.profile.list!
    redirect_to(edit_profile_path)
  end

  def unlist
    current_lawyer.profile.unlist!
    redirect_to(edit_profile_path)
  end

  def search
    @lawyer = Lawyer.new
  end

  def name_search
    @lawyer = Lawyer.new
  end

  private

  def lawyer_params
    # params.require(:lawyer).permit(Lawyer.search_criteria)
    params.require(:lawyer).permit(:profile_image, :profile_image_cache,
      :designation, :years_of_experience, :location, :bio,
      :consultation_hourly_rate, :public_id)
  end
end
