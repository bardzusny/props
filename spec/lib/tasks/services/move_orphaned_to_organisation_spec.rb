require 'rails_helper'
require_relative '../../../../lib/tasks/services/move_orphaned_to_organisation'

describe MoveOrphanedToOrganisation do
  describe '#call' do
    it 'sets organisation_id for orphaned pros' do
      organisation = create :organisation
      orphaned_props = build_list(:prop, 10, :without_organisation).map do |prop|
        prop.save(validate: false)
        prop
      end

      MoveOrphanedToOrganisation.new(organisation.id).call

      orphaned_props.each(&:reload)

      expect(orphaned_props.map(&:organisation_id))
        .to all(eq(organisation.id))
    end

    it 'leaves props that already have organisation_id unchanged' do
      organisation = create :organisation
      props = create_list :prop, 10

      MoveOrphanedToOrganisation.new(organisation.id).call

      expect(Prop.all).to eq(props)
    end

    it 'sets organisation_id for orphaned users' do
      organisation = create :organisation
      orphanded_users = create_list :user, 10

      MoveOrphanedToOrganisation.new(organisation.id).call

      orphanded_users.each do |user|
        expect(user.reload.organisations).to include organisation
      end
    end

    it 'leaves users that already have organisation unchanged' do
      organisation = create :organisation
      users = create_list :user, 10, :with_organisation

      MoveOrphanedToOrganisation.new(organisation.id).call

      expect(User.all).to eq(users)
    end
  end
end
