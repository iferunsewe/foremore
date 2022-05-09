class AddTeamIdToAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :team_id, :integer
  end
end
