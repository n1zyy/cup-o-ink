class PrintServersController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :find_by_id

  def index
  end

  private

  def find_by_id
    if params[:id] || params[:filename]
      @print_server = CupsTranlator.fromFileCupMaybeSave(:id       => params[:id],
                                                         :filename => filename_param
                                                        ).print_server
    end
  end

  def filename_param
    Rails.root.join("printers", params[:filename]).to_s if params[:filename]
  end
end
