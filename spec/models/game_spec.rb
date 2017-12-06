require_relative '../spec_helper'

describe Game do
    context 'basic associations and attributes' do
        it 'belongs to user' do
            should belong_to :user
        end

        it 'should have game type attribute' do
            should validate_presence_of :game_type
        end

        it 'should have score attribute' do
            should validate_presence_of :score
        end

        it 'should have time taken attribute' do
            should validate_presence_of :time_taken
        end

        it 'should have rounds attribute' do
            should validate_presence_of :rounds
        end
    end

    context 'with valid input' do
        let!(:user) { Fabricate(:user) }

        it 'creates new game' do
            game = user.games.create(Fabricate.attributes_for(:game))

            expect(game.valid?).to be true
            expect(Game.count).to eq 1
        end

        it 'associates new game with user' do
            game = user.games.create(Fabricate.attributes_for(:game))

            expect(user.games.count).to eq 1
            expect(user.games.first.id).not_to eq nil
        end
    end

    context 'with invalid input' do
        let!(:user) { Fabricate(:user) }

        it 'does not create new game' do
            game = user.games.build(game_type: '')

            expect(user.games.count).to eq 0
        end

        it 'does not create new association with user' do
            invalid_game = user.games.create(game_type: '')

            expect(invalid_game.id).to eq nil
        end
    end
end