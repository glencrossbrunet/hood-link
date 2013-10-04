# coding: utf-8

module LayoutHelper
  
  def render_flashes
    flashes = [:error, :alert, :notice, :success].map do |key|
      render_flash(key) if flash[key]
    end
    flashes.compact.reduce(:+)
  end
  
  def render_flash(key)
    content_tag(:div, flash[key], class: "flash #{key}")
  end

end