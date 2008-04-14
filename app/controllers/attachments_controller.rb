class AttachmentsController < ApplicationController
    def new
        @attachment = Attachment.new
        respond_to do |format|
            format.html
            format.js { render :partial => "attachments/form.html.haml", :layout => false, :locals => { :content => Content.find( params[:content_id] ) } }
        end
    end

	def create
      sleep 5 # for some reason, on Windows we have to give the OS a chance to pull in all the data
              # see http://railsforum.com/viewtopic.php?id=6307 for why I had to do this
	  @attachment = Attachment.new(params[:attachment])
	  if @attachment.save
	    notify :notice, 'Attachment was successfully added.'
	  else
	    notify :error, 'Adding attachment failed.'
	  end
      redirect_to content_url(:id => params[:attachment][:content_id])
	end
    
    def index
    end
    
    def destroy
        @attachment = Attachment.find( params[:id] )
        @attachment.destroy
        @id = params[:id]
    end

end