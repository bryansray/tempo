class Team < ActiveRecord::Base
  # Associations
  has_many :members, :dependent => :destroy
  has_many :users, :through => :members
  has_many :iterations
  has_many :cards
  has_many :properties, :as => :scope
  
  belongs_to :project
  
  def to_s
	self.title
  end
  
  def current_iteration
    col = self.iterations.find(:all, :conditions => ["? BETWEEN started_at and ended_at", Date.today])
	if !col.nil? then return col[0] end
  end
  
  def next_available_startdate
    lastday = Iteration.find_by_sql("SELECT MAX(ended_at) AS lastday FROM iterations WHERE team_id = " + self.id.to_s)[0].lastday

    if lastday.nil?
        dtm = Date.today
    else
        dtm = Date.parse( lastday )
    end

	while dtm.wday != 1
		dtm = dtm.next()
    end

    return dtm
  end
end
