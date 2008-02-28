class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :blog_id, :user_id
      t.integer :status_id

      t.string :permalink
      t.boolean :allow_comments

  	  t.datetime :published_at
		
      t.timestamps 
    end
  end

  def self.down
    drop_table :posts
  end
end
