class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string :name

      t.timestamps null: false
    end

    add_index :organisations, :name, unique: true
  end
end
