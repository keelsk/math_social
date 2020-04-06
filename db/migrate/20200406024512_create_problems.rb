class CreateProblems < ActiveRecord::Migration[6.0]
  def change
    create_table :problems do |t|
      t.string :question
      t.integer :answer
      # t.integer :user_id
      t.timestamps
    end
  end
end
