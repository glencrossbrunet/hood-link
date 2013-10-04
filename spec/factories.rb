FactoryGirl.define do
  sequence(:email) { |n| "test#{n}@mep.org" }

  factory :user do
    email { generate(:email) }
    password 'verysecret'
    password_confirmation { password }
    
    trait :organized do
      ignore do
         organization { association(:organization) }
      end
    end

    factory :member do
      organized
      after(:create) { |user, evaluator| user.add_role(:member, organization) }
    end
    
    factory :admin do
      organized
      after(:create) { |user, evaluator| user.add_role(:admin, evaluator.organization) }
    end
    
    factory :god do
      after(:create) { |user| user.add_role(:admin) }
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
end