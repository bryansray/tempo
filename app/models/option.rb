class Option < ActiveRecord::Base
	belongs_to :property
	
	def to_s
		self.name
	end
end
