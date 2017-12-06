module ApplicationHelper
    def current_path
        request.env['PATH_INFO'].gsub('/', '')
    end

    def print_person_info(person)
        full_name = person[:firstName] + ' ' + person[:lastName]
        job_title = person[:jobTitle]

        "#{job_title}, #{full_name}."
    end

    def user_games_excluding_learning(user)
        user.games.where.not("games.game_rules = ? AND games.game_rules = ?", 'learn', 'practice').size
    end
end
