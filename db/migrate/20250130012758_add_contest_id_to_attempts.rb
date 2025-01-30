class AddContestIdToAttempts < ActiveRecord::Migration[7.1]
  def change
    add_column :attempts, :contest_id, :bigint, null: true
    add_foreign_key :attempts, :contests
    add_index :attempts, :contest_id
  end
end
