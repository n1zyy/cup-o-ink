class Toner
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :name
  attr_accessor :color
  attr_accessor :high_level
  attr_accessor :level
  attr_accessor :low_level
  attr_accessor :type
  attr_accessor :class_name

  def initialize(options = {})
    options.each { |n, v| public_send("#{n}=", v) }
  end

  def name=(value)
    @name = value.gsub('\\','')
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