require 'securerandom'

class User < ActiveRecord::Base
  rolify

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
   def self.parse(raw)
     where(email: raw.strip.downcase).first_or_initialize.tap do |user|
       unless user.persisted?
         user.password = user.password_confirmation = SecureRandom.hex
         user.save
       end
     end
   end
  
end
