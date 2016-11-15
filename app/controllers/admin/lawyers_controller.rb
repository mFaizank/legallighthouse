class Admin::LawyersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @lawyers = Lawyer.order(created_at: :desc)
    @listed_count = Lawyer.where(listed: true).count
  end
end
