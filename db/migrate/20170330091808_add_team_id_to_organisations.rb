class AddTeamIdToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :team_id, :string
    add_index :organisations, :team_id, unique: true
  end
end
