class Iteration < ActiveRecord::Base
  #Associations
  belongs_to :team
  has_many :cards
  has_many :properties, :as => :scope
  
  def day_of
  	if Date.today > self.ended_at
  		self.days
  	else
  		calculate_working_days( self.started_at, Date.today, [0,6] )
  	end
  end
  
  def days
    calculate_working_days( self.started_at, self.ended_at, [0,6] )
  end
  
  #the number of cards with the Status property set to complete
  def cards_completed
    cards = Card.find(:all, :conditions => "options.name = 'Complete'", :include => [:card_properties, { :card_properties => [:property, :option] }] )
  end
  
  def to_s
    self.started_at.strftime( "%m/%d" ) << " - " << self.ended_at.strftime( "%m/%d" )
  end
  
  #this is the capacity  of the iteration
  def developer_hours
    self.days * self.team.members.count * 8
  end
  
  #estimated size of the iteration
  def card_hours
	if self.cards.size > 0
		self.cards.sum( :estimated )
	else
		0
	end
  end
  
  # sums up the hours in the actual column for cards in this iteration
  def actual_hours
    sum_card_field( :actual, :complete )
  end
  
  #real hours is the actual hours logged on completed cards plus the estimated hours on remaining cards in this iteration
  #this allows us to see over estimates and under estimates
  def real_hours
    actual_hours + self.remaining_hours
  end
  
  #estimated size of incomplete cards
  def remaining_hours
    sum_card_field( :estimated, :incomplete )
  end
  
  def count_cards( card_status )
  	case card_status
  		when :incomplete
  			condition = "(card_properties.option_id IS NULL OR options.name <> 'Complete') AND (properties.scope_id IS NULL AND properties.name = 'Status')"
  		when :complete
  			condition = "options.name = 'Complete' AND (properties.scope_id IS NULL AND properties.name = 'Status')"
  		else
  			condition = ""
  	end
  	retVal = self.cards.count( :include => :card_properties, :joins => "LEFT JOIN options ON options.id = card_properties.option_id INNER JOIN properties ON properties.id = card_properties.property_id", :conditions => condition )
  	retVal ||= 0
  end
  
  def sum_card_field( field, card_status )
  	case card_status
  		when :incomplete
  			condition = "(card_properties.option_id IS NULL OR options.name <> 'Complete') AND (properties.scope_id IS NULL AND properties.name = 'Status')"
  		when :complete
  			condition = "options.name = 'Complete' AND (properties.scope_id IS NULL AND properties.name = 'Status')"
  		else
  			condition = ""
  	end
  	retVal = self.cards.sum( field, :include => :card_properties, :joins => "LEFT JOIN options ON options.id = card_properties.option_id INNER JOIN properties ON properties.id = card_properties.property_id", :conditions => condition )
  	retVal ||= 0
  end

  
  def calculate_working_days(d1,d2,wdays)
    diff = d2 - d1 + 1 #I think this needs to add 1 day, otherwise you are always short 1 day
    holidays = 0
    ret = (d2-d1).divmod(7)
    holidays =  ret[0].truncate * wdays.length
    d1 = d2 - ret[1]
    while(d1 <= d2)
      if wdays.include?(d1.wday)
         holidays += 1
      end
      d1 += 1
    end
    diff - holidays
  end
end
