class Game < ApplicationRecord
    belongs_to :user

    validates_presence_of :game_type, :score, :time_taken, :rounds

    def attributes
        {
            game_rules: self.game_rules,
            score: self.score,
            rounds: self.rounds,
            finished_rounds: self.finished_rounds
        }
    end
end