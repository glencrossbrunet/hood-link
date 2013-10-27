# organizations

organizations = YAML.load(IO.read(Rails.root.join 'db', 'organizations.yml'))
organizations.each do |data|
	Organization.where(data).first_or_create
end

# displays

displays = YAML.load(IO.read(Rails.root.join 'db', 'displays.yml'))
displays.each do |data|
	Display.where(data).first_or_create
end

# sample metrics

sample_metrics = YAML.load(IO.read(Rails.root.join 'db', 'sample_metrics.yml'))
sample_metrics.each do |data|
  SampleMetric.where(name: data).first_or_create
end