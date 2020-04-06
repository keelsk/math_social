class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :password
      t.string :username
      t.string :img_url
    end
  end
end
