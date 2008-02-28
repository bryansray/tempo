class CreateComments < ActiveRecord::Migration
	def self.up
	  create_table :comments, :force => true do |t|	 
      t.integer :user_id 
	    t.string :name, :email

	    t.integer :commentable_id
		  t.string :commentable_type

	    t.timestamps
	  end
	
	  add_index :comments, ["user_id"], :name => "fk_comments_user"
	end
	
	def self.down
	  drop_table :comments
	end
end
