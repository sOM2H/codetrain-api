class CreateProblemTags < ActiveRecord::Migration[7.1]
  def change
    create_table :problem_tags do |t|
      t.references :problem, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
