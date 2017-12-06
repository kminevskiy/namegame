class FixGamesTableName < ActiveRecord::Migration[5.1]
  def change
    rename_table :ganes, :games
  end
end
