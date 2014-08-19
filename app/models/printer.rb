class Printer
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :name
  attr_accessor :server

  def initialize(options = {})
    options.each { |n, v| public_send("#{n}=", v) }
  end

  def raw_object
    @raw_object ||= CupsPrinter.new(name, :hostname => server)
  end

  def raw_attributes
    @raw_attributes ||= raw_object.attributes
  end

  def model
    raw_attributes['printer-info'] rescue ""
  end

  def location
    raw_attributes['printer-location'] rescue ""
  end

  def toner_status
    # marker-colors
    # marker-levels
    # marker-names
    # marker-types
    toners = []
    # Some printers have no toner cartridges:
    return toners unless raw_attributes['marker-colors'].present?
    colors = raw_attributes['marker-colors'].split(',')
    levels = raw_attributes['marker-levels'].split(',')
    names  = raw_attributes['marker-names'].split(',')
    types  = raw_attributes['marker-types'].split(',')
    highs  = raw_attributes['marker-high-levels'].split(',') rescue []
    lows   = raw_attributes['marker-low-levels'].split(',') rescue []
    msgs   = raw_attributes['marker-messages'].split(',') rescue []
    #print "Colors: #{colors}"
    colors.each_with_index do |color, index|
      level = levels[index]
      name = names[index].gsub('\\', '').strip
      type = types[index]
      range = lows[index]..highs[index]
      msg = msgs[index]
      toners << {:color => color, :level => level, :name => name, :type => type, :range => range.to_s, :message => msg}
    end
    return toners
  end
end
