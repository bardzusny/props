require_relative './services/move_orphaned_to_organisation'

namespace :organisations do
  desc 'Assign unassigned users and props to the organisation'
  task :assign_unassigned_users_and_props, [:organisation_id] => :environment do |_task, args|
    organisation_id = args[:organisation_id]
    MoveOrphanedToOrganisation.new(organisation_id).call
  end
end
