class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
    	t.integer :status_id, :user_id
    	
    	# These are miscellaneous fields associated with pieces of content
    	t.string :title, :keywords
    	t.text :text

		# These fields are responsible for the polymorphic relationships
		# from other models that have a piece of content
		t.integer :owner_id
		t.string :owner_type
		
		t.boolean :allow_comments, :is_think_box

		t.timestamps 
    end
  end

  def self.down
    drop_table :contents
  end
end