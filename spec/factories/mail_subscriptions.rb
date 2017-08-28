FactoryGirl.define do
  factory :mail_subscription do
    association :user, factory: :user
    interval 'daily'
    active 'true'
  end
end
