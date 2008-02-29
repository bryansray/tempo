require 'google_api'
require 'digest/sha1'

class User < ActiveRecord::Base
  include Google
  
  @@login = 'scott.stevenson@datacert.com'
  @@password = 'datacert'
  
  # Associations
  has_many :blogs
  has_many :pages
  has_many :visits
  has_many :contents, :extend => Content::AssociationMethods
  has_many :members, :dependent => :destroy
  has_many :teams, :through => :members
  
  #scope_out :content, :conditions => ["contents.published = ?", true]
  
  def published_pages(options = {})
    options.merge!(:include => :content, :conditions => ["pages.user_id = ? AND contents.published = ?", id, true])
    Page.find(:all, options)    
  end

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email, :first_name
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :first_name, :last_name, :email, :password, :password_confirmation
  
  def to_s
    "#{first_name} #{last_name}"
  end
  
  # Google Shared Entries
  def google_feeds
	if google_number.nil? || google_number.blank?
		@listEntries = []
	else
		rdr = GoogleReader.new( @@login, @@password )
		@listEntries = rdr.getSharedFeed( google_number )
	end
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    DateTime.now < DateTime.parse(remember_token_expires_at)
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def forgot_password
    @forgot_password = true
    self.make_password_reset_code
  end
  
  def recently_forgot_password?
    @forgotten_password
  end

  def team_history
	audits = []
	self.members.each do |m|
		audits += m.audits
	end
	return audits
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_password_reset_code
      self.password_reset_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)
    end
end