FactoryGirl.define do
  factory :organisation do
    sequence :name do |n|
      "Organisation #{n}"
    end
    team_id { FFaker::Guid.guid }
  end
end
