class NotesController < ApplicationController
  layout 'user_application'
    
  def create
  	@video = Video.find(params[:note][:video_id])
  	@notes = @video.note || Note.create(specialty: @video.specialty, 
    						                        video: @video, 
    						                        user: current_user)
  	@notes.content = params[:note][:content]
  	@notes.title = params[:note][:title]
  	
  	if @notes.save
  		@saved = true
  	end

  	respond_to do |format|
      format.html
      format.js
    end
  end

  def update
	  @video = Video.find(params[:note][:video_id])
  	@notes = @video.note
  	@notes.content = params[:note][:content]
  	@notes.title = params[:note][:title]

  	if @notes.save
  		@saved = true
  	end

  	respond_to do |format|
      format.html
      format.js
    end
  end

  def load
    @notes = Note.find(params[:note_id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy

  end
end
