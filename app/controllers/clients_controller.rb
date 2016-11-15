class ClientsController < ApplicationController
  before_action :authenticate_lawyer!

  def index
    @clients = current_lawyer.clients
    @clients = if params[:status] && Client.statuses.keys.include?(params[:status])
      @clients.where(status: Client.statuses[params[:status]])
    else
      @clients.all
    end
  end

  def show
    @client = current_lawyer.clients.find(params[:id])
  end
end
