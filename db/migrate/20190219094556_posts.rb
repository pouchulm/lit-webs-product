class Posts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :artwork_url
      t.string :artist_name
      t.string :collection_name
      t.string :track_name
      t.text :preview_url
      t.text :comment
      t.integer :user_id
      t.timestamps null:false
    end
  end
end
