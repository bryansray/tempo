class Attachment < ActiveRecord::Base
  # Associations
  has_one :content, :as => :owner
  
  has_attachment :storage => :file_system, 
	:path_prefix => 'public/attachments',
	:size => 1..15.megabytes

  validates_as_attachment
  validates_uniqueness_of :filename
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    #this changes the path to public/attachments/content_id/filename
    File.join(RAILS_ROOT, file_system_path, ('%06d' % self.content_id), thumbnail_name_for(thumbnail))
  end
end