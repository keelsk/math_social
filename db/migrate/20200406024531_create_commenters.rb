class CreateCommenters < ActiveRecord::Migration[6.0]
  def change
    create_table :commenters do |t|
      t.string :name
      t.string :img_url
      t.integer :solution_id
    end
  end
end
