Fabricator(:game) do
    game_type { %w(team time practice matt).sample }
    score { rand 10 + 1 }
    rounds 5
    time_taken 0
    game_rules { %w(practice everyone matt team learn).sample }
    time_limit false
    finished_rounds 0
end