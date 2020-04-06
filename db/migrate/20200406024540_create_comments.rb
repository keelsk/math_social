class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :commenter_id
    end
  end
end
