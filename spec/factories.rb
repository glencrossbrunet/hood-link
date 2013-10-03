FactoryGirl.define do
  sequence(:email) { |n| "test#{n}@mep.org" }

  factory :user do
    email { generate(:email) }
    password 'verysecret'
    password_confirmation 'verysecret'
  end

end