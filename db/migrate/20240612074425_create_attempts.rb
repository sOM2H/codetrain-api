class CreateAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :attempts do |t|
      t.text :code
      t.references :user, null: false, foreign_key: true
      t.references :problem, null: false, foreign_key: true
      t.references :language, null: false, foreign_key: true
      t.integer :result, default: 0

      t.timestamps
    end
  end
end
