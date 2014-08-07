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

  def index
    @title, @notes = Note.includes(:specialty, :category, :noteable).get_notes(current_user, params[:specialty_id], params[:category_id])

    respond_to do |format|
      format.html
      format.pdf { doc_raptor_send }
    end
  end

  def show
    @notes = Note.find_by(user: current_user, id: params[:id])

    unless @notes
      redirect_to notes_path
    end

    respond_to do |format|
      format.html
      format.pdf { doc_raptor_send }
    end
  end

  def doc_raptor_send(options = { })
    default_options = { 
      name:           controller_name,
      document_type:  request.format.to_sym,
      test:           !Rails.env.production?
    }
    options = default_options.merge(options)
    options[:document_content] ||= render_to_string
    ext = options[:document_type].to_sym

    response = DocRaptor.create(options)
    if response.code == 200
      send_data response, filename: "#{options[:name]}.#{ext}", type: ext
    else
      redirect_to :back, notice: "#{response.code}: #{response.body}"
    end
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
      params[:note][:noteable_type].classify.constantize.find(params[:note][:noteable_id])
    end
end
