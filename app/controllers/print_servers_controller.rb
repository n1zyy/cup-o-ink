class PrintServersController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :find_by_id

  def index
    render 'show' if @print_server
  end

  private

  def find_by_id
    @print_server = PrintServer.new(:id => params[:id]) if params[:id]
  end
end
