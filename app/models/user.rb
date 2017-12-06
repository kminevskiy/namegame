class User < ApplicationRecord
    has_many :games

    validates_presence_of :first_name, :last_name, :email, :password

    VALID_EMAIL_REGEX = /\A[\w\-.+]+@\w+\.\w+\z/

    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

    has_secure_password password_confirmation: false
    validates_length_of :password, minimum: 10

    def self.top_ten_by_score
        joins(:games).where.not("games.game_rules = ? AND games.game_rules = ?", 'practice', 'learn').select("users.*, SUM(games.score) AS total_score").group("users.id").order("SUM(games.score) DESC").limit(10)
    end
end