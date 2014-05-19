class NotesController < ApplicationController
  layout 'user_application'
  respond_to :html, :js
    
  def create
    @noteable = find_noteable params
  	@notes = @noteable.notes.find_by(user: current_user) || Note.new( noteable: @noteable, 
                                                                      user: current_user)
    @notes.update(title: params[:note][:title], content: params[:note][:content])
  	if @notes.save
  		@saved = true
  	end
  end

  def update
    @noteable = find_noteable params
  	@notes = @noteable.notes.find_by(user: current_user)
  	@notes.update(title: params[:note][:title], content: params[:note][:content])
  	if @notes.save
  		@saved = true
  	end
  end

  def load
    @notes = Note.cached_find(params[:id])
  end

  def destroy
    @notes = Note.cached_find(params[:id])
    if @notes.cached_user == current_user || current_user.admin?
      @notes.destroy
      redirect_to :back, notice: "Successfully destroyed notes."
    else
      render status: :forbidden
    end
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
