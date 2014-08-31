class PrintServer
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :id, :filename, :printers

  def initialize(options = {})
    options.each { |n, v| public_send("#{n}=", v) }
  end

  def name
    id || filename
  end
end
