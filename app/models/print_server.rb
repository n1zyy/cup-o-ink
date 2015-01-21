class PrintServer
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :id, :filename, :printers

  def initialize(options = {})
    options.each { |n, v| public_send("#{n}=", v) }
  end

  # display
  def name
    id || short_filename
  end

  def short_filename
    File.basename(filename, '.yml') if filename
  end
end
