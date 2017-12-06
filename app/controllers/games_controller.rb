class GamesController < ApplicationController
    before_action :unauthenticated?
    before_action :find_current_game, only: [:play, :submit, :report]

    def new
        if allowed_game_mode?
            render :new, locals: { game_type: params[:game_type] }
        else
            redirect_to games_path
        end
    end

    def create
        rounds = params[:rounds][:total].to_i
        time_limit = !!params[:time_limit]
        game_type = params[:game_type]
        
        new_game_data = {
                            game_type: game_type,
                            rounds: rounds, 
                            time_limit: time_limit,
                            finished_rounds: 0, 
                            user_id: current_user, 
                            time_taken: 0, 
                            score: 0
                        }

        game = GameSetupService.new.setup_game(new_game_data)
        game.save

        redirect_to play_game_path(game.id)
    end

    def report
        redirect_to(users_path) && return if !@game

        if @game.finished_rounds != @game.rounds
            @game.finished_rounds = @game.rounds
            @game.save
        end

        render :report, locals: { game: @game.attributes }
    end

    def play
        if @game.finished_rounds == @game.rounds
            redirect_to report_game_path(@game)
        else
            new_round_data = GameSetupService.new.pull_game_data(@game.game_type)

            render :play, locals: { game_data: new_round_data }
        end
    end

    def submit
        selected, answer = params[:person].keys.first.split('#')

        if answer == selected
            @game.score += 2
            flash[:success] = 'Correct answer.'
        else
            flash[:error] = 'Incorrect answer.'
        end

        @game.finished_rounds += 1
        @game.save

        redirect_to play_game_path(@game)
    end

    private

    def allowed_game_mode?
        %w(team practice matt random learn).include? params[:game_type]
    end

    def find_current_game
        @game = Game.find_by(id: params[:id], user_id: current_user)
    end
end