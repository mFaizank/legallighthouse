class ApplicationsController < ApplicationController
  before_action :authenticate_admin!, except: [:new, :create]

  def index
    @applications = Application.order(created_at: :desc)
    @applied_count = Application.count
    @approved_count = Application.where.not(approved_at: nil).count
    @rejected_count = Application.where.not(rejected_at: nil).count
    @pending_count = @applied_count - (@approved_count + @rejected_count)
  end

  def show
    load_application
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(application_params)

    if @application.save
      LawyerMailer.application_email(@application).deliver
      AdminMailer.application_email(@application).deliver
    else
      set_variables

      render :new
    end
  end

  def approve
    load_application

    @application.approve!
    LawyerMailer.approval_email(@application).deliver

    redirect_to @application
  end

  def reject
    load_application

    @application.reject!
    LawyerMailer.rejection_email(@application).deliver

    redirect_to @application
  end

  private

  def application_params
    params.require(:application).permit :first_name, :last_name, :bar_number,
      :year_of_call, :firm, :phone_number, :email, { specializations: [] },
      :good_standing, :malpractice_insurance, :extra_credentials,
      :cv, :cv_cache, :agree, :terms, { bars: [] }, { languages: [] }
  end

  def load_application
    @application = Application.find(params[:id])
  end

  def set_variables
    @invalid = !@application.valid?
    @areas = @application.other(:specializations).join ','
    @languages = @application.other(:languages).join ','
  end
end
