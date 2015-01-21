# this should be a lib
require 'yaml'

# parallels print_server
# this is both the disk serializer and cups driver serializer
# acts as the print_server, printer, and toner factory
# probably makes sense to break into many classes
class CupsTranslator
  attr_accessor :attrs, :id, :filename
  def initialize(attrs = {})
    @attrs = attrs
  end

  def search(hostname)
    @id = hostname
    @attrs = CupsPrinter.get_all_printer_attrs(:hostname => hostname) if hostname
    self
  end

  def load(filename)
    @filename = filename
    @attrs = YAML::load_file(filename) if filename
    self
  end

  def save(filename)
    File.write(filename, attrs.to_yaml) if filename && !File.exist?(filename)
    self
  end

  def print_server
    PrintServer.new(:id       => @id,
                    :filename => @filename,
                    :printers => printers)
  end

  def printers
    attrs.map { |k, v| printer(k, v) }
  end

  def self.fromFileCupMaybeSave(id, filename)
    if id
      new.search(id).save(filename)
    elsif filename
      new.load(filename)
    end
  end

  private

  def toner(values)
    correlate_attributes(values, %w(marker-colors marker-names marker-types marker-messages) +
                         %w(marker-high_levels marker-levels marker-low-levels)).map do |c, n, t, msg, hl, l, ll|
      Toner.new(
        :color      => c,
        :name       => n,
        :type       => t,
        :message    => msg,
        :high_level => hl,
        :level      => l,
        :low_level  => ll,
      )
    end.compact
  end

  # TODO: return Printer
  def printer(name, values)
    Printer.new(
      :name     => name,
      :info     => values['printer-info'].presence,
      :location => values['printer-location'].presence,
      :model    => values['printer-make-and-model'].presence,
      :toners   => toner(values)
    # "copies"=>"1"
    # "device-uri"=>"dnssd://EPSON%20WF-2540%20Series._ipp._tcp.local./"
    # "finishings"=>"3"
    # "job-hold-until"=>"no-hold"
    # "job-priority"=>"50"
    # "job-sheets"=>"none,none"
    # "number-up"=>"1"
    # "printer-commands"=>"none"
    # "printer-is-accepting-jobs"=>"true"
    # "printer-is-shared"=>"false"
    # "printer-state"=>"3"
    # "printer-state-change-time"=>"1408200052"
    # "printer-state-reasons"=>"none"
    # "printer-type"=>"69242956"
    )
  end

  # take multiple parallel arrays, and "zip" them together
  def correlate_attributes(values, attributes)
    list_attributes(values, attributes.first).zip(*attributes[1..-1].map { |attr| list_attributes(values, attr)})
  end

  def list_attributes(values, name)
    values[name].try(:split, ',') || []
  end
end
