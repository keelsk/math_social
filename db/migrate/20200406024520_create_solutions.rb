class CreateSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :solutions do |t|
      t.string :explanation
      t.integer :student_answer
      t.datetime :solved_at
      t.datetime :updated_at
      t.integer :problem_id
    end
  end
end
