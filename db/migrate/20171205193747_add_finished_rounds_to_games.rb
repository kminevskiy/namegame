class AddFinishedRoundsToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :finished_rounds, :int
  end
end
