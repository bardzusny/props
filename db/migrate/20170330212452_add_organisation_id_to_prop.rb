class AddOrganisationIdToProp < ActiveRecord::Migration
  def change
    add_reference :props, :organisation, index: true, foreign_key: true
  end
end
