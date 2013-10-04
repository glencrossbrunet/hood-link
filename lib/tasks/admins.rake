desc 'grant meta :admin role to each email in config/admins.yml'
task :admins => :environment do
  puts 'administrators:'
  emails = YAML.load_file(Rails.root.join 'config', 'admins.yml')
  puts emails
  
  admins = emails.map{ |email| User.parse(email).reload }
  admins.each do |admin|
    admin.grant(:admin) unless admin.has_role? :admin
    admin.skip_confirmation!
  end
end