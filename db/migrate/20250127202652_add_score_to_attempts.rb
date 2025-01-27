class AddScoreToAttempts < ActiveRecord::Migration[7.1]
  def change
    add_column :attempts, :score, :float, default: 0.0, null: false
  end
end
