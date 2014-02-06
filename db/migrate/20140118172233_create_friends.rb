class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :idfacebook
      t.string :first_name
      t.string :last_name
      t.references :user, index: true

      t.timestamps
    end
  end
end
