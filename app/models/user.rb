# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

require 'securerandom'

class User < ActiveRecord::Base
  rolify
  
  has_many :organizations, through: :roles, source: :resource, source_type: 'Organization'
  
  devise :database_authenticatable, :registerable, :recoverable, 
      :rememberable, :trackable, :validatable
         
  def self.parse(raw)
   where(email: raw.strip.downcase).first_or_initialize.tap do |user|
     unless user.persisted?
       user.password = user.password_confirmation = SecureRandom.hex
       user.save
     end
   end
  end
  
end
