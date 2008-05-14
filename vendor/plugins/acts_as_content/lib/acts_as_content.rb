module ActiveRecord
  module Acts
    module Content
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
    
    module ClassMethods
      has_one :content, :as => :owner
      
      include ActiveRecord::Acts::Content::InstanceMethods
    end
    
    module InstanceMethods
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Content)