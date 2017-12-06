class AddTimeLimitFlagToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :time_limit, :boolean
  end
end
