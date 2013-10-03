FactoryGirl.define do
  sequence(:email) { |n| "test#{n}@mep.org" }

  factory :user do
    email { generate(:email) }
    password 'verysecret'
    password_confirmation { password }
  end
  
  sequence(:subdomain) { |n| "domain#{n}" }
  
  factory :organization do
    name 'Test Organization'
    subdomain { generate(:subdomain) }
  end
end