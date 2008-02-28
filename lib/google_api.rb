require 'net/https'
require 'rubygems'
require 'xmlsimple'
# Use this module to access the Goole RSS reader. Should be extensible
# to allow classes for other Google services
#
module Google
  class GoogleAPI
    #class variables
    @@root = "http://www.google.com"
    @@auth = "https://www.google.com/accounts/ClientLogin"
    
    #class methods
    def GoogleAPI.paths
      return { :root => @@root, :auth => @@auth }
    end
    
    #constructor
    def initialize( email, password, service )
      @options = { 'Email' => email, 'Passwd' => password, 'source' => 'com-dc-googleapi-v1', 'service' => service }
      @sid = self.getSID()
      @cookie = self.getCookie()
    end
    
    #instance variables
    attr_reader :options, :sid, :cookie
    
    #instance methods
    def getUrl( url )
      parts = URI.parse( url )
      http = Net::HTTP.new( parts.host, parts.port )
      return http.request_get( url, { 'Cookie' => @cookie } ).body
    end
    
    def postUrl( url, data, ssl = false )
      url = URI.parse( @@auth )
      http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = ssl
        response = http.start do |http|
        request = Net::HTTP::Post.new(url.path)
        if !data.nil?
          request.set_form_data( data, '&') 
        end
        http.request( request )
      end
      case response
        when Net::HTTPSuccess #, Net::HTTPRedirection
          return response
        else
          return "error"
      end
    end
    
    def getSID()
      response = self.postUrl( @@auth, @options, true )
      return /SID=(\S*)/.match( response.body )[1]
    end
    
    def getCookie()
      return "Name=SID;SID=#{@sid};Domain=.google.com;Path=/;Expires=160000000000"
    end
    
    def getToken( url )
      return getUrl( url )
    end
  end
  
  class GoogleChart
	@@simple =  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	@@seps = { :simple => "," }
	@@encFlag = { :simple => "s" }
	
	def GoogleChart.build_url( width, height, data, type, xMax, yMax, options = {} )
		params = []
		encodedData = []
		options[:encoding] ||= :simple
		y_intersect = "0"
		#required parameters
		params << "chs=#{width}x#{height}"
		case type
			when :linexy
				params << "cht=lxy"
				data.each_index { |i| 
					#in order to put labels at the Y intersection (where x=0) we need to know the un-encoded data value
					if i % 2 == 1 && data[i].length > 0
						y_intersect << ",#{data[i][0]}"
					end
					encodedData << GoogleChart.encode_data( data[i], i % 2 == 0 ? xMax : yMax, options[:encoding] )
				}
			else
				params << "cht=lc"
				data.each_index { |i| 
					encodedData << GoogleChart.encode_data( data[i], yMax, options[:encoding] ) }
		end
		params << ("chd=#{@@encFlag[options[:encoding]]}:" << encodedData.join( @@seps[options[:encoding]] ))
		qstring = "chxt=x,y" << "&amp;chxr=0,0,#{xMax}|1,0,#{yMax}&amp;chxp=1,#{y_intersect},#{yMax}" << "&amp;" << params.join("&amp;")
		qstring << "&amp;" << options[:google_chart_options] if !options[:google_chart_options].nil?
		return "http://chart.apis.google.com/chart?" << qstring
	end
	
	def GoogleChart.encode_data( data, max, encoding )
		encoding = :simple if encoding.nil?
		case encoding
			when :simple
				return "_" if data.length == 0
				data.map! { |d| GoogleChart.simple_encode( d, max ) }
				data.join
		end
	end
  
	def GoogleChart.simple_encode( val, max )
		return "_" if max == 0
		@@simple[(val*(@@simple.length-1))/max,1]
	end
  end
  
  class GoogleReader
    #class variables
    @@reader = GoogleAPI.paths[:root] + "/reader"
    @@shared = @@reader + "/public/atom/user/%s/state/com.google/broadcast"
    @@unread = @@reader + "/atom/user/-/state/com.google/reading-list"
    @@feed = @@reader + "/atom/feed/", # use this to retrieve any RSS feed, append the url of the feed to this url
    @@subscription = @@reader + "/api/0/subscription/edit"
    @@feedlist = @@reader + "/api/0/subscription/list"
    @@token = @@reader + "/api/0/token"
    @@userinfo = @@reader + "/public/atom/user/17274847198237398017/state/com.google/broadcast"
    
    #class methods
    def GoogleReader.paths
      return { :reader => @@reader, :unread => @@unread, :feed => @@feed,
        :subscription => @subscription, :token => @token }
    end
    
    #constructor
    def initialize( email, password )
      @api = GoogleAPI.new( email, password, 'reader' )
    end
    
    #instance variables
    attr_reader :api
    
    #instance methods
    def getUnread
      return getEntryCollection( XmlSimple.xml_in( @api.getUrl( @@unread ) ) )
    end
    
    def getFeedList
      return getFeedCollection( XmlSimple.xml_in( @api.getUrl( @@feedlist ), { 'KeyAttr' => 'name' } ) ) 
    end
	
	def getSharedFeed( google_number )
		return getEntryCollection( XmlSimple.xml_in( @api.getUrl( sprintf( @@shared, google_number ) ) ) )
	end
    
    def modify_subscription( feed, title, action )
      client = URI.escape( @api.options["Email"], Regexp.new("[^#{URI::PATTERN::UNRESERVED}]" ) )
      feed = URI.escape( "feed/" + feed, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]" ) )
      title = URI.escape( title, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]" ) )
      #url = @@subscription + "?client=client:#{client}&ac=#{action}&s=feed%2F#{feed}&token=#{api.sid}"
      url = @@subscription + "?client=client:#{@api.options['Email']}&ac=#{action}&t=#{title}&s=#{feed}&token=#{@api.getToken(@@token)}" 
      return @api.getUrl( url )
    end
  
    def subscribe( url, title )
        modify_subscription( url, title, "subscribe" )
        return GoogleFeed.new( url, title )
    end 
  
    def unsubscribe_from( url )
      return modify_subscription( url, '', "unsubscribe" )
    end
    
    def getEntryCollection( xml )
      rv = []
      xml["entry"].each do |entry|
        rv[rv.length] = GoogleEntry.new( 
          entry["title"][0]["content"], 
          entry["author"][0]["name"], 
          Date.parse( entry["published"][0] ), 
          entry.has_key?("content") ? entry["content"]["content"] : entry["summary"][0]["content"],
          entry["link"][0]["href"])
      end
      return rv
    end
    
    def getFeedCollection( xml )
      rv = []
      xml["list"]["subscriptions"]["object"].each do |feed|
        rv[rv.length] = GoogleFeed.new( feed["string"]["id"]["content"], feed["string"]["title"]["content"] )
      end
      return rv
    end
  end
  
  class GoogleEntry
    #constructor
    def initialize( title, author, ts, content, url )
      @title = title
      @author = author
      @timestamp = ts
      @content = content
      @url = url
    end
    
    #instance variables
    attr_reader :title, :author, :timestamp, :content, :url
  end
  
  class GoogleFeed
    #constructor
    def initialize( url, title )
      @title = title
      @url = url
    end
    
    #instance variables
    attr_reader :title, :url
  end
  
end