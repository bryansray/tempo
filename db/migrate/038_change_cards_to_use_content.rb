class ChangeCardsToUseContent < ActiveRecord::Migration
    def self.up
      # Move existing data to content table
      execute "INSERT INTO contents (title, text, owner_id, owner_type, created_at, updated_at) SELECT title, description, id, 'Card', created_at, updated_at FROM cards"
      # Drop unnecessary columns
      remove_column :cards, :title
      remove_column :cards, :description
      # Re-index so that ferret searches will find this new content
      Content.rebuild_index
    end

    def self.down
      # Put columns back
      add_column :cards, :title, :string
      add_column :cards, :description, :text
      # Refesh model
      Card.reset_column_information
      # Populate data from content model and destory content
      Card.find(:all).each do |card|
        if !card.content.nil? then
          card.update_attribute :title, card.content.title
          card.update_attribute :description, card.content.text
          card.content.destroy
        end
      end
    end
  end
