class PrintServersController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    if params[:id]
      show
      render 'show'
    end
  end

  def show
    @server = PrintServer.new(:id => params[:id])
    @printers = @server.printers
  end
end
