class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.string :email
      t.string :password_digest

      t.timestamps
    end

    create_table :ganes do |t|
      t.string :game_type
      t.integer :score
      t.integer :rounds
      t.integer :time_taken
      t.belongs_to :user, index: true
    end
  end
end
