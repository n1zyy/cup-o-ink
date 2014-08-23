class Toner
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  IGNORE_WORDS = [
    "Toner", "Cartridge", "module",
    # "Developer",
    "Canon", "HP", # brands
    /GPR-\d*/, # model number
    /\[.\]/, # [c] [m] [y] [k]
  ]

  attr_accessor :color
  attr_accessor :name
  attr_accessor :type
  attr_accessor :messages
  attr_accessor :high_level
  attr_accessor :level
  attr_accessor :low_level

  def initialize(options = {})
    options.each { |n, v| public_send("#{n}=", v) }
  end

  def name=(value)
    @name = value.gsub('\\','')
  end

  # presentation

  def visible?
    !hidden?
  end

  def hidden?
    level.to_i < 0 || %w(Cleaner Waste Transfer Feed Assembly Roll).detect { |pattern| name.include?(pattern) }
  end

  def short_name
    @short_name ||=
      begin
        short_name = name.dup
        IGNORE_WORDS.map { |ignore| short_name.gsub!(ignore, '') }
        short_name.gsub!(/\[.\]/,'')
      end
  end

  def css_color
    color.size == 7 && color =~ /^#/ ? color : "#ffffff"
  end

  def level_percent
    (level.to_i * 100 / (high_level || 100)).to_i if level
  end

  def class_name
    case level.to_i
    when 1..5
      "danger"
    when 6..15
      "warning"
    else
      ""
    end
  end
end
