class Printer
  include ActiveModel::AttributeMethods
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  attr_accessor :name
  attr_accessor :info
  attr_accessor :location
  attr_accessor :model
  attr_accessor :toners

  def initialize(options = {})
    options.each { |n, v| public_send("#{n}=", v) }
  end

  def visible_toners
    toners.select { | toner | toner.visible? }
  end

  def visible_toners?
    visible_toners.present?
  end
end
