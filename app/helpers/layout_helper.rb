# coding: utf-8

module LayoutHelper
  
  def render_flashes
    flashes = [:error, :alert, :notice, :success].map do |key|
      render_flash(key) if flash[key]
    end
    flashes.compact.reduce(:+)
  end
  
  def render_flash(key)
    content_tag(:div, class: "alert-box #{key}") do
      (flash[key] + '<a href="#" class="close">×</a>').html_safe
    end
  end

end