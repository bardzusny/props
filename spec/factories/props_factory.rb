FactoryGirl.define do
  factory :prop do
    body FFaker::Lorem.paragraph
    association :propser, factory: :user
    association :organisation, factory: :organisation
    after :build do |prop|
      prop.prop_receivers.new(user: create(:user))
    end

    trait :with_upvote do
      after(:create) do |prop|
        prop.upvotes << create(:upvote)
      end
    end

    trait :without_organisation do
      organisation nil
    end
  end
end
