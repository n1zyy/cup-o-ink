class PrintServer
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :id
  attr_accessor :raw_object

  def initialize(options = {})
    options.each { |n, v| public_send("#{n}=", v) }
  end

  def printers
    list = []
    print "So, umm... #{@hostname}?"
    #foo = CupsPrinter.get_all_printer_names(:hostname => @hostname)
    #printers = CupsPrinter.get_all_printer_names(:hostname => @hostname)
    _printers = CupsPrinter.get_all_printer_attrs(:hostname => @hostname)

    # This is all very confusing, so we're going to reformat all of this.
    printers = []
    _printers.each do |k,v|
      # Separate out toners
      puts "k: #{k.inspect} // v: #{v.inspect}"
      toner_info = []
      if v['marker-colors'].present?
        colors = v['marker-colors'].split(',') rescue []
        levels = v['marker-levels'].split(',') rescue []
        names  = v['marker-names'].split(',') rescue []
        types  = v['marker-types'].split(',') rescue []
        v['marker-colors'].split(',').size.times do |i|
          #colors = v['marker-colors'].split(',') rescue []
          #levels = v['marker-levels'].split(',') rescue []
          #names  = v['marker-names'].split(',') rescue []
          #types  = v['marker-types'].split(',') rescue []
          tonerclass = case levels[i].to_i
          when 1..5
            "danger"
          when 6..15
            "warning"
          else
            ""
          end
          puts "--tonerclass: #{tonerclass}"
          toner_info << {
            :name => names[i].gsub('\\',''),
            :color => colors[i],
            :level => levels[i],
            :type => types[i],
            :class => tonerclass
          }
        end
      end
      printers << {
        :name => k,
        :info => v['printer-info'],
        :location => v['printer-location'],
        :model => v['printer-make-and-model'],
        :toner_info => toner_info
      }
    end

    #print "** printers; #{printers.inspect}"
    #printers.each do |printer_name|
    #  begin
    #    list << Printer.new(printer_name, hostname)
    #  rescue Exception => e
    #    print "*** #{e.message}"
    #  end
    #end
    return printers
  end
end
