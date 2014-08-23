module ApplicationHelper

  def server_icon
    %{<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
           width="64px" height="64px" viewBox="0 0 32 32">
        <use xlink:href="#server">
      </svg>}.html_safe
  end

  def printer_icon
    %{<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
           width="64px" height="64px" viewBox="0 0 16 15">
        <use xlink:href = "#printer"/>
      </svg>}.html_safe
  end

  def toner_icon(toner)
    %{<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
   width="64px" height="124px" viewBox="0 0 64 64" enable-background="new 0 0 64 64">
        <g class="#{toner.class_name}">
          <use xlink:href = "#cartridge" />
          <use xlink:href = "#ink"  style="fill: #{toner.css_color}" />
          <text x="10" y="76">#{toner.level_percent}%</text>
          <text x="5" y="90">#{toner.short_name}</text>
        </g>
      </svg>}.html_safe
  end
end
