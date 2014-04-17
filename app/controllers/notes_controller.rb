class NotesController < ApplicationController
  layout 'user_application'
    
  def create
    @noteable = find_noteable params

  	@notes = @noteable.notes.find_by(user: current_user) || Note.new( noteable: @noteable, 
                                                                      user: current_user)

    if @notes.noteable_type == "specialty"
      @notes.specialty = @notes.noteable
    else
      @notes.specialty = @notes.noteable.specialty
    end

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
    @noteable = find_noteable params
  	@notes = @noteable.notes.find_by(user: current_user)
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

  private

    def find_noteable(params)
      if params[:note][:noteable_type] == "Video"
        params[:note][:noteable_type].classify.constantize.friendly.find(params[:note][:noteable_id])
      else
        params[:note][:noteable_type].classify.constantize.find(params[:note][:noteable_id])
      end
    end
end
