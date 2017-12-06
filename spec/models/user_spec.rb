require_relative '../spec_helper'

describe User do
    context 'basic associations and attributes' do
        it 'should have first name attribute' do
            should validate_presence_of :first_name
        end

        it 'should have last name attribute' do
            should validate_presence_of :last_name
        end

        it 'should have email attribute' do
            should validate_presence_of :email
        end

        it 'should validate uniqueness of email attribute' do
            should validate_uniqueness_of(:email).case_insensitive
        end

        it 'should have password attribute' do
            should validate_presence_of :password
        end

        it 'verifies password complexity' do
            should have_secure_password
            should validate_length_of :password
        end

        it 'has many association with games' do
            should have_many :games
        end
    end

    context 'with valid input' do
        let!(:user) { Fabricate(:user) }

        it 'creates new user' do
            expect(user.valid?).to be true
        end

        it 'persists valid user' do
            expect(User.count).to eq 1
        end
    end

    context 'with invalid input' do
        let(:user) { Fabricate.build(:user, first_name: '') }

        it 'does not create new user' do
            expect(user.valid?).to be false
        end

        it 'does not persist invalid user' do
            expect(User.count).to eq 0
        end
    end
end