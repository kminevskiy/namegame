class GameSetupService
    attr_reader :cache

    def initialize
        @cache = CachingService.new
    end

    def setup_game(new_game_data)
        build_game_object(new_game_data)
    end

    def pull_game_data(game_type)
        cache.get_random_profiles(game_type, 5)
    end

    private

    def build_game_object(game_data)
        case game_data[:game_type]

        when 'team'
            return Game.new(game_type: 'current_team',
                            rounds: game_data[:rounds],
                            time_limit: game_data[:time_limit],
                            finished_rounds: 0,
                            user_id: game_data[:user_id],
                            time_taken: 0,
                            score: 0,
                            game_rules: 'team'
                    )
        when 'matt'
            return Game.new(game_type: 'matt',
                            rounds: game_data[:rounds],
                            time_limit: game_data[:time_limit],
                            finished_rounds: 0,
                            user_id: game_data[:user_id],
                            time_taken: 0,
                            score: 0,
                            game_rules: 'matt'
                    )
        when 'everyone'
            return Game.new(game_type: 'all',
                            rounds: game_data[:rounds],
                            time_limit: game_data[:time_limit],
                            finished_rounds: 0,
                            user_id: game_data[:user_id],
                            time_taken: 0,
                            score: 0,
                            game_rules: 'everyone'
                    )
        when 'learn'
            return Game.new(game_type: 'current_team',
                            rounds: game_data[:rounds],
                            time_limit: false,
                            finished_rounds: 0,
                            user_id: game_data[:user_id],
                            time_taken: 0,
                            score: 0,
                            game_rules: 'learn'
                    )
        when 'practice'
            return Game.new(game_type: 'all',
                            rounds: game_data[:rounds],
                            time_limit: false,
                            finished_rounds: 0,
                            user_id: game_data[:user_id],
                            time_taken: 0,
                            score: 0,
                            game_rules: 'practice'
                    )
        end
    end
end