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
  
  def templates(*path)
    dir = Rails.root.join(*path)
    basepath = Pathname.new(dir)
    scripts = Dir.glob("#{dir}/**/*.ejs").map do |path|
      template(path, basepath)
    end
    scripts.join.html_safe
  end
  
  def template(path, basepath)
    relative_path = Pathname.new(path).relative_path_from(basepath).to_path
    *path_to, filename = relative_path.split('/')
    name_without_ext = File.basename(filename, '.*')
    name = [*path_to, name_without_ext].join('/')
    
    raw = IO.read(path)
    %Q(<script name="#{name}" type="text/template">#{raw}</script>)
  end

end