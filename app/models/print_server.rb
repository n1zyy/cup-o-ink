class PrintServer
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :id

  def initialize(options = {})
    options.each { |n, v| public_send("#{n}=", v) }
  end

  def printers
    @printers ||= CupsTranslator.cupsToPrinter(CupsPrinter.get_all_printer_attrs(:hostname => id)).tap {
      CupsPrinter.close  
    }
  end
end
