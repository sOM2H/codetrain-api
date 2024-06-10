class CreateTests < ActiveRecord::Migration[7.1]
  def change
    create_table :tests do |t|
      t.references :problem, null: false, foreign_key: true
      t.text :input, null: false
      t.text :output, null: false

      t.timestamps
    end
  end
end
