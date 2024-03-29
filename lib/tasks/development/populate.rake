namespace :dev do
  task :populate => %w(environment db:schema:load admins) do		
    mcgill = Organization.create(name: 'McGill University', subdomain: 'mcgill')
    
    users = 20.times.map do
      User.parse(Faker::Internet.email).tap do |user|
        user.add_role(:member, mcgill)
      end
    end
    
    users.last.add_role(:admin, mcgill)
		
		127.times do
			mcgill.fume_hoods.create(external_id: SecureRandom.hex)
		end
  end
end