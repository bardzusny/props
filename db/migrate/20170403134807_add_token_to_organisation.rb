class AddTokenToOrganisation < ActiveRecord::Migration
  def change
    add_column :organisations, :token, :string
  end
end
