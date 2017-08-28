require 'rails_helper'
include RankingsHelpers

describe PropsRepository do
  let(:repo) { described_class.new }

  describe '#all' do
    let!(:prop1) { create(:prop) }
    let!(:prop2) { create(:prop) }

    it 'returns all the props' do
      expect(repo.all).to eq [prop1, prop2]
    end
  end

  describe '#add' do
    let(:jack) { create(:user) }
    let(:jane) { create(:user) }
    let(:john) { create(:user) }
    let(:organisation) { create(:organisation) }
    let(:archived_user) { create(:user, archived_at: Time.now) }
    let(:user_ids) { "#{john.id},#{jane.id}" }
    let(:attributes) do
      {
        body: "some multiline\nline prop body",
        user_ids: user_ids,
        propser_id: jack.id,
        organisation_id: organisation.id,
      }
    end

    context 'with valid attributes' do
      it 'creates a prop' do
        expect { repo.add(attributes) }.to change { Prop.count }.by(1)
      end

      it "doesn't create a prop when propser is included in users" do
        attrs = attributes.merge(propser_id: jane.id)
        expect { repo.add(attrs) }.to_not change { Prop.count }
      end
    end

    context 'with invalid attributes' do
      it "doesn't raise an error when user_ids param is missing" do
        expect { repo.add({}) }.to_not raise_exception
      end
      context 'when user_ids is empty' do
        let(:user_ids) { '' }
        it "doesn't create a prop" do
          expect { repo.add(attributes) }.to_not change { Prop.count }
        end

        it "doesn't raise an error" do
          expect { repo.add(attributes) }.to_not raise_exception
        end
      end

      context 'when user_ids is an empty array' do
        let(:user_ids) { '[]' }
        it "doesn't create a prop" do
          expect { repo.add(attributes) }.to_not change { Prop.count }
        end

        it "doesn't raise an error" do
          expect { repo.add(attributes) }.to_not raise_exception
        end
      end

      context 'when user_ids include archived user id' do
        let(:user_ids) { "[#{archived_user.id}]" }

        it "doesn't create a prop" do
          expect { repo.add(attributes) }.to_not change { Prop.count }
        end

        it "doesn't raise an error" do
          expect { repo.add(attributes) }.to_not raise_exception
        end
      end

      context 'when @here present in body' do
        let(:invalid_attributes) { attributes.merge(body: 'Some body with @here,') }
        it "doesn't create a prop" do
          expect { repo.add(invalid_attributes) }.to_not change { Prop.count }
        end

        it "doesn't raise an error" do
          expect { repo.add(attributes) }.to_not raise_exception
        end
      end

      context 'when @here present in body' do
        let(:invalid_attributes) { attributes.merge(body: '>@channel in body oh no!') }
        it "doesn't create a prop" do
          expect { repo.add(invalid_attributes) }.to_not change { Prop.count }
        end

        it "doesn't raise an error" do
          expect { repo.add(attributes) }.to_not raise_exception
        end
      end
    end
  end

  describe '#count_per_time_range' do
    let(:processor_arguments) do
      {
        time_range_string: time_range_string,
        props_repository: described_class.new,
        organisation: organisation,
      }
    end
    let(:time_range_processor) { Rankings::ProcessTimeRange.new(processor_arguments) }
    let(:time_range) { time_range_processor.time_range }
    let(:time_interval) { time_range_processor.time_interval }
    let(:jack) { create(:user) }
    let(:jane) { create(:user) }
    let(:john) { create(:user) }
    let(:organisation) { create(:organisation) }
    let(:today) { Time.zone.now.beginning_of_day }
    let!(:kudos) do
      [
        create_kudos_for_user(jane, jack, today),
        create_kudos_for_user(jane, john, today - 2.days),
        create_kudos_for_user(jack, john, today - 2.days),
        create_kudos_for_user(jane, john, today - 3.weeks),
        create_kudos_for_user(jack, jane, today - 4.months),
      ]
    end

    subject { repo.count_per_time_range(organisation, time_interval, time_range) }

    before do
      organisation.add_user(jack)
      organisation.add_user(john)
      organisation.add_user(jane)
    end

    context 'when statistics are requested in weekly time range' do
      let(:time_range_string) { 'weekly' }
      let(:expected_result) do
        {
          (today - 2.days).beginning_of_day => 2,
          today.beginning_of_day => 1,
        }
      end

      it 'returns time stamps with organisation kudos count from last week' do
        expect(subject).to eq expected_result
      end
    end

    context 'when statistics are requested in monthly time range' do
      let(:time_range_string) { 'monthly' }
      let(:expected_result) do
        {
          (today - 3.weeks).beginning_of_day => 1,
          (today - 2.days).beginning_of_day => 2,
          today.beginning_of_day => 1,
        }
      end

      it 'returns time stamps with organisation kudos count from last month' do
        expect(subject).to eq expected_result
      end
    end

    context 'when returned statictics should be grouped by months' do
      let(:this_month) { Time.zone.now.beginning_of_month }
      let!(:kudos) do
        [
          create_kudos_for_user(jane, jack, this_month + 1.day),
          create_kudos_for_user(jane, john, this_month - 2.days),
          create_kudos_for_user(jack, john, this_month - 5.days),
          create_kudos_for_user(jane, john, this_month - 4.weeks),
          create_kudos_for_user(jack, jane, this_month - (6.months + 2.days)),
          create_kudos_for_user(jack, jane, this_month - (13.months + 2.days)),
          create_kudos_for_user(jack, jane, this_month - (15.months + 2.days)),
        ]
      end

      context 'when statistics are requested in yearly time range' do
        let(:time_range_string) { 'yearly' }
        let(:expected_result) do
          {
            this_month - 7.months => 1,
            this_month - 1.month => 3,
            this_month => 1,
          }
        end

        it 'returns time stamps with organisation kudos count from last year' do
          expect(subject).to eq expected_result
        end
      end

      context 'when statistics are requested in etire time range' do
        let(:time_range_string) { 'all' }

        context 'when kudos were given in long time range' do
          let(:expected_result) do
            {
              this_month - 16.months => 1,
              this_month - 14.months => 1,
              this_month - 7.months => 1,
              this_month - 1.month => 3,
              this_month => 1,
            }
          end

          it 'returns time stamps with organisation kudos count in month interval' do
            expect(subject).to eq expected_result
          end
        end

        context 'when first kudos were given not long ago' do
          let!(:kudos) do
            [
              create_kudos_for_user(jane, jack, this_month + 1.day),
              create_kudos_for_user(jack, john, this_month + 1.day),
              create_kudos_for_user(jane, john, this_month - 2.days),
              create_kudos_for_user(jack, john, this_month - 5.days),
              create_kudos_for_user(jane, john, this_month - 4.weeks),
            ]
          end
          let(:expected_result) do
            {
              this_month - 4.weeks => 1,
              this_month - 5.days => 1,
              this_month - 2.days => 1,
              this_month + 1.day => 2,
            }
          end

          it 'returns time stamps with organisation kudos count in day interval' do
            expect(subject).to eq expected_result
          end
        end
      end
    end
  end
end
