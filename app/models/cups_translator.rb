# this should be a lib

class CupsTranslator
  def cupsToPrinter(cups_printers)
    cups_printers.map { |k, v| printer(k, v) }
  end

  def toner(values)
    correlate_attributes(values).map do |color, level, name, type|
      Toner.new(
        :name       => name,
        :color      => color,
        :level      => level,
        :type       => type,
      )
    end.compact
  end

  # TODO: return Printer
  def printer(name, values)
    Printer.new(
      :name     => name,
      :info     => values['printer-info'],
      :location => values['printer-location'],
      :model    => values['printer-make-and-model'],
      :toners   => toner(values)
    )
  end

  def correlate_attributes(values)
    colors = list_attributes(values, 'marker-colors')
    levels = list_attributes(values, 'marker-levels')
    names  = list_attributes(values, 'marker-names')
    types  = list_attributes(values, 'marker-types')
    colors.zip(levels, names, types)
  end

  def list_attributes(values, name)
    values[name].try(:split, ',') || []
  end

  def self.cupsToPrinter(cups_printers)
    new.cupsToPrinter(cups_printers)
  end
end

