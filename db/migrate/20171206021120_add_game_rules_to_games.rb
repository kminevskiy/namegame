class AddGameRulesToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :game_rules, :string
  end
end
