class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.order(created_at: :desc)
    @count = User.count
  end
end
