class CreateContestsUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :contests_users do |t|
      t.references :contest, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
