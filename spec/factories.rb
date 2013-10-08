FactoryGirl.define do
  sequence(:email) { |n| "test#{n}@mep.org" }

  factory :user do
    email { generate(:email) }
    password 'verysecret'
    password_confirmation { password }
    
    factory :admin do
      after(:create) { |u| u.add_role(:admin) }
    end
  end
  
  sequence(:subdomain) { |n| "domain#{n}" }
  
  factory :organization do
    name 'Test Organization'
    subdomain { generate(:subdomain) }
  end
  
  factory :role do
    name 'member'
    association :resource, factory: :organization
  end
  
  factory :filter do
    key 'building'
    association :organization, factory: :organization
  end
end