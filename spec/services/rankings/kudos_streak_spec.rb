require 'rails_helper'
include RankingsHelpers

describe Rankings::KudosStreak do
  let(:organisation) { create(:organisation) }
  let(:mark) { create(:user, :with_organisation, name: 'Mark Banana') }
  let(:john) { create(:user, :with_organisation, name: 'John Smith') }
  let(:jane) { create(:user, :with_organisation, name: 'Jane Doe') }
  let(:props_repository) { PropsRepository.new }
  let(:users_repository) { UsersRepository.new }
  let(:processor_arguments) do
    {
      time_range_string: time_range_string,
      props_repository: props_repository,
      organisation: organisation,
    }
  end
  let(:time_range_processor) { Rankings::ProcessTimeRange.new(processor_arguments) }

  subject do
    described_class.new(users_repository: users_repository,
                        props_repository: props_repository,
                        organisation: organisation,
                        time_range: time_range)
  end

  before do
    organisation.add_user(mark)
    organisation.add_user(john)
    organisation.add_user(jane)
  end

  def user_with_streak(user, streak)
    {
      streak: streak,
      user: {
        'id' => user.id,
        'name' => user.name,
        'email' => user.email,
        'uid' => user.uid,
        'avatar' => user.avatar,
      },
    }
  end

  describe '#kudos_streak' do
    let(:time_range) { time_range_processor.time_range }
    let(:today) { Time.current.to_date }
    let(:two_weeks_ago) { today - 2.weeks }
    let(:three_months_ago) { today - 3.months }
    let(:two_years_ago) { today - 2.years }
    let!(:kudos) do
      [
        create_kudos_for_user(jane, mark, today),
        create_kudos_for_user(mark, john, two_weeks_ago),
        create_kudos_for_user(mark, john, two_weeks_ago - 1.day),
        create_kudos_for_user(jane, john, three_months_ago),
        create_kudos_for_user(jane, john, three_months_ago - 1.day),
        create_kudos_for_user(jane, john, three_months_ago - 2.days),
        create_kudos_for_user(john, jane, two_years_ago),
      ]
    end

    context 'when statistics are requested in weekly time range' do
      let(:time_range_string) { 'weekly' }
      let(:expected_result) do
        [
          user_with_streak(jane, 1),
        ]
      end

      it 'returns users with their highest kudos streaks within last week' do
        expect(subject.kudos_streak).to eq expected_result
      end
    end

    context 'when statistics are requested in monthly time range' do
      let(:time_range_string) { 'monthly' }
      let(:expected_result) do
        [
          user_with_streak(mark, 2),
          user_with_streak(jane, 1),
        ]
      end

      it 'returns users with their highest kudos streaks within last month' do
        expect(subject.kudos_streak).to eq expected_result
      end
    end

    context 'when statistics are requested in yearly time range' do
      let(:time_range_string) { 'yearly' }
      let(:expected_result) do
        [
          user_with_streak(jane, 3),
          user_with_streak(mark, 2),
        ]
      end

      it 'returns users with their highest kudos streaks within last year' do
        expect(subject.kudos_streak).to eq expected_result
      end
    end

    context 'when statistics are requested in etire time range' do
      let(:time_range_string) { 'all' }
      let(:expected_result) do
        [
          user_with_streak(jane, 3),
          user_with_streak(mark, 2),
          user_with_streak(john, 1),
        ]
      end

      it 'returns users with their highest kudos streaks' do
        expect(subject.kudos_streak).to eq expected_result
      end

      context 'when user get few kudos at the same day it does not count to streak' do
        let(:time_range_string) { 'all' }
        let!(:kudos) do
          [
            create_kudos_for_user(jane, mark, today),
            create_kudos_for_user(jane, mark, today),
            create_kudos_for_user(jane, mark, today),
            create_kudos_for_user(jane, mark, today),
            create_kudos_for_users([jane, mark], john, today),
            create_kudos_for_user(mark, john, two_weeks_ago),
            create_kudos_for_user(mark, john, two_weeks_ago),
            create_kudos_for_user(mark, john, two_weeks_ago),
            create_kudos_for_user(mark, john, two_weeks_ago - 1.day),
            create_kudos_for_user(jane, john, three_months_ago),
            create_kudos_for_user(jane, john, three_months_ago - 1.day),
            create_kudos_for_user(jane, john, three_months_ago - 1.day),
            create_kudos_for_user(jane, john, three_months_ago - 1.day),
            create_kudos_for_user(jane, john, three_months_ago - 2.days),
            create_kudos_for_user(john, jane, two_years_ago),
            create_kudos_for_users([john, jane], mark, two_years_ago - 1.day),
          ]
        end
        let(:expected_result) do
          [
            user_with_streak(jane, 3),
            user_with_streak(mark, 2),
            user_with_streak(john, 2),
          ]
        end

        it 'returns users with their highest kudos streaks' do
          expect(subject.kudos_streak).to eq expected_result
        end
      end
    end

    context 'when multiple organisations have kudos' do
      let(:organisation_one)   { create(:organisation) }
      let(:organisation_two)   { create(:organisation) }
      let(:organisation_three) { create(:organisation) }
      let(:mark) { create(:user, name: 'Mark Banana') }
      let(:john) { create(:user, name: 'John Smith') }
      let(:jane) { create(:user, name: 'Jane Doe') }
      let(:alex) { create(:user, name: 'Alex Crow') }
      let(:dave) { create(:user, name: 'Dave Starsky') }
      let(:leia) { create(:user, name: 'Leia Organa') }
      let!(:kudos) do
        [
          create_kudos_in_org(organisation_one, mark, john, today),
          create_kudos_in_org(organisation_one, mark, john, today - 1.day),
          create_kudos_in_org(organisation_two, jane, alex, two_weeks_ago),
          create_kudos_in_org(organisation_two, jane, alex, two_weeks_ago - 1.day),
          create_kudos_in_org(organisation_three, leia, dave, three_months_ago),
          create_kudos_in_org(organisation_three, leia, dave, three_months_ago - 1.day),
        ]
      end
      let(:time_range_string) { 'all' }
      let(:expected_result) do
        [
          user_with_streak(jane, 2),
        ]
      end
      let(:processor_arguments) do
        {
          time_range_string: time_range_string,
          props_repository: props_repository,
          organisation: organisation_two,
        }
      end
      let(:time_range_processor) { Rankings::ProcessTimeRange.new(processor_arguments) }

      subject do
        described_class.new(users_repository: users_repository,
                            props_repository: props_repository,
                            organisation: organisation_two,
                            time_range: time_range)
      end

      before do
        organisation_one.add_user(mark)
        organisation_one.add_user(john)
        organisation_two.add_user(jane)
        organisation_two.add_user(alex)
        organisation_three.add_user(dave)
        organisation_three.add_user(leia)
      end

      it 'returns streak only for given organisation (organisation_two in this case)' do
        expect(subject.kudos_streak).to eq expected_result
      end
    end
  end
end
