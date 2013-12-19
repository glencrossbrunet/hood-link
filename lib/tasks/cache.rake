namespace :cache do
	task :warm => :environment do
		Organization.find_each do |organization|
			print "warming #{organization.subdomain}... "
			organization.daily_intervals(Date.yesterday, 1.hour)
			puts 'done'
		end
	end
end