class Abc < ActiveRecord::Migration
  def change 
    drop_table :memberships
    create_table :memberships do |t|
      t.integer :beer_club_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
