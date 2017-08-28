FactoryGirl.define do
  factory :membership do
    association :user, factory: :user
    association :organisation, factory: :organisation
  end
end
