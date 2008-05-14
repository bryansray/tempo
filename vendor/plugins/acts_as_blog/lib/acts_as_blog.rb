# ActsAsBlog - used to convert redcloth,markdown,smarty to html.  also evals <ruby> code and escpates html if needed
require 'active_record'

## Lets create a namespace
module TextConversion
	## make it acts_as_blog
	module Acts
		module Blog

      def self.included(base)
        base.extend(ClassMethods)
      end

      # make sure our new methods are loaded
      module ClassMethods
        def acts_as_blog
          class_eval do
            extend TextConversion::Acts::Blog::SingletonMethods
          end
        end
      end

      # This will render your redcloth,markdown, or smartypants into html format
			# passing :filter_html as one of the restrictions will remove all html tags 
			# other than those created using red_cloth.  You may pass any of the normal filters
			# into RedCloth.  This was taken from the Typo Trunk.  Gotta love open source!
			# In the future I hope to be able to pass rhtml template strings in sections
			# marked with the <view></view> tag. 
			# ie <view><%= link_to('test',:controller => 'test')%></view>
			# the interior text would be then converted into html.
      module SingletonMethods
        def convert_to_html(txt, text_filter, restrictions = [])
		      return "" if txt.blank?
    		  return txt if text_filter.blank?

					
    		  text_filter.split.each do |filter|
      		  case filter
      		  when "markdown":
        		  txt = BlueCloth.new(txt, restrictions).to_html
        		when "textile":
        		  txt.gsub!('\n','<br />')
        		  txt = encode_html(txt) if restrictions.include?(:filter_html)
        		  txt = RedCloth.new(txt, restrictions).to_html(:textile)
        		when "smartypants":
       		   txt = RubyPants.new(txt).to_html
      		  end
     		 	end
      		return txt
    		end
    		
				# Taken from BlueCloth since RedCloth's filter_html is broken
    		def encode_html( str )
      		str.gsub!( "<", "&lt;" )
      		str.gsub!( ">", "&gt;" )
      		str
    		end
        # etc...
      end

      end

    end
  end

# reopen ActiveRecord and include all the above to make
# them available to all our models if they want it
ActiveRecord::Base.class_eval do
  include TextConversion::Acts::Blog
end
