require 'rails_helper'
include RankingsHelpers

describe Rankings::TopKudosers do
  shared_context 'multiple organisations have kudos' do
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
        create_kudos_in_org(organisation_one, mark, john, time_now),
        create_kudos_in_org(organisation_one, mark, john, time_now - 1.day),
        create_kudos_in_org(organisation_two, jane, alex, time_now - 3.days),
        create_kudos_in_org(organisation_two, jane, alex, time_now - 4.days),
        create_kudos_in_org(organisation_two, alex, jane, time_now - 4.days),
        create_kudos_in_org(organisation_three, leia, dave, time_now - 14.days),
        create_kudos_in_org(organisation_three, leia, dave, time_now - 15.days),
      ]
    end
    let(:time_range_string) { 'all' }

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
  end

  let(:organisation) { create(:organisation) }
  let(:mark) { create(:user) }
  let(:john) { create(:user) }
  let(:jane) { create(:user, name: 'Jane Doe') }
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
  let(:time_range) { time_range_processor.time_range }

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

  describe '#hero_of_the_week' do
    let(:time_range_string) { 'weekly' }
    let(:time_now) { Time.zone.now }
    let!(:kudos) do
      [
        create_kudos_for_user(jane, mark, time_now),
        create_kudos_for_user(jane, john, time_now),
        create_kudos_for_user(mark, john, time_now),
      ]
    end
    let(:expected_result) do
      {
        user: jane.name,
        kudos_count: 2,
      }
    end

    it 'returns the user with the most kudos' do
      expect(subject.hero_of_the_week).to eq expected_result
    end

    context 'when multiple organisations have kudos' do
      include_context 'multiple organisations have kudos'

      it 'returns results only for given organisation (organisation_two in this case)' do
        expect(subject.hero_of_the_week).to eq expected_result
      end
    end
  end

  describe '#top_kudosers' do
    let(:time_now) { Time.zone.now }
    let!(:kudos) do
      [
        create_kudos_for_user(jane, mark, time_now),
        create_kudos_for_user(jane, john, time_now - 2.days),
        create_kudos_for_user(mark, john, time_now - 5.days),
        create_kudos_for_user(jane, john, time_now - 2.weeks),
        create_kudos_for_user(mark, jane, time_now - 3.months),
        create_kudos_for_user(mark, jane, time_now - 5.months),
        create_kudos_for_user(mark, jane, time_now - 7.months),
        create_kudos_for_user(mark, jane, time_now - 2.years),
        create_kudos_for_user(john, jane, time_now - 2.years),
      ]
    end

    def user_with_kudos_count(user, kudos_count)
      {
        kudos_count: kudos_count,
        user: {
          'id' => user.id,
          'name' => user.name,
          'email' => user.email,
          'uid' => user.uid,
          'avatar' => user.avatar,
        },
      }
    end

    context 'when statistics are requested in weekly time range' do
      let(:expected_result) do
        {
          top_kudosers: [
            user_with_kudos_count(jane, 2),
            user_with_kudos_count(mark, 1),
          ],
        }
      end
      let(:time_range_string) { 'weekly' }

      it 'returns users with their kudos count from last week' do
        expect(subject.top_kudosers).to eq expected_result
      end
    end

    context 'when statistics are requested in monthly time range' do
      let(:expected_result) do
        {
          top_kudosers: [
            user_with_kudos_count(jane, 3),
            user_with_kudos_count(mark, 1),
          ],
        }
      end
      let(:time_range_string) { 'monthly' }

      it 'returns users with their kudos count from last month' do
        expect(subject.top_kudosers).to eq expected_result
      end
    end

    context 'when statistics are requested in yearly time range' do
      let(:expected_result) do
        {
          top_kudosers: [
            user_with_kudos_count(mark, 4),
            user_with_kudos_count(jane, 3),
          ],
        }
      end
      let(:time_range_string) { 'yearly' }

      it 'returns users with their kudos count from last year' do
        expect(subject.top_kudosers).to eq expected_result
      end
    end

    context 'when statistics are requested in etire time range' do
      let(:expected_result) do
        {
          top_kudosers: [
            user_with_kudos_count(mark, 5),
            user_with_kudos_count(jane, 3),
            user_with_kudos_count(john, 1),
          ],
        }
      end
      let(:time_range_string) { 'all' }

      it 'returns users with their kudos count' do
        expect(subject.top_kudosers).to eq expected_result
      end
    end

    context 'when multiple organisations have kudos' do
      include_context 'multiple organisations have kudos'

      let(:expected_result) do
        {
          top_kudosers: [
            user_with_kudos_count(jane, 2),
            user_with_kudos_count(alex, 1),
          ],
        }
      end

      it 'returns results only for given organisation (organisation_two in this case)' do
        expect(subject.top_kudosers).to eq expected_result
      end
    end
  end
end
