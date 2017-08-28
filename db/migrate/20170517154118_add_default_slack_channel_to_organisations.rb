class AddDefaultSlackChannelToOrganisations < ActiveRecord::Migration
  def change
    add_column :organisations, :slack_channel, :string
  end
end
