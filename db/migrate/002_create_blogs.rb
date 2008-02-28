class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.boolean :allow_comments

      t.timestamps 
    end
  end

  def self.down
    drop_table :blogs
  end
end
