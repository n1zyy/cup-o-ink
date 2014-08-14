class Printer < ActiveRecord::Base
  attr_accessor :raw_object
  attr_accessor :name
  attr_accessor :server

  def initialize(name, server_name)
    @name = name
    @server = server_name
    @raw_object = CupsPrinter.new(name, :hostname => server_name)
    @name
  end

  def attributes
    @attributes ||= @raw_object.attributes
  end

  def model
    attributes['printer-info'] rescue ""
  end

  def location
    attributes['printer-location'] rescue ""
  end

  def toner_status
    # marker-colors
    # marker-levels
    # marker-names
    # marker-types
    toners = []
    # Some printers have no toner cartridges:
    return toners unless attributes['marker-colors'].present?
    colors = attributes['marker-colors'].split(',')
    levels = attributes['marker-levels'].split(',')
    names  = attributes['marker-names'].split(',')
    types  = attributes['marker-types'].split(',')
    highs  = attributes['marker-high-levels'].split(',') rescue []
    lows   = attributes['marker-low-levels'].split(',') rescue []
    msgs   = attributes['marker-messages'].split(',') rescue []
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
