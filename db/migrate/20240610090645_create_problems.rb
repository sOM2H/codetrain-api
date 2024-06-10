class CreateProblems < ActiveRecord::Migration[7.1]
  def change
    create_table :problems do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :complexity, default: 1
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
