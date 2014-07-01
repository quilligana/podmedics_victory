class VideosController < ApplicationController
  layout 'user_application'

  def index
    if params[:tag]
      @videos = Video.includes(:specialty).tagged_with(params[:tag])
    elsif params[:search]
      @videos = Video.includes(:specialty).search(params[:search])
    else
      @videos = Video.includes(:specialty).all
    end
  end

  def show
    @video = Video.includes(:specialty, :author, :tags).friendly.find(params[:id])
    @specialty = @video.specialty

    check_unlock if current_user.is_trial_member?

    @video.increment_views
    @progress = Vimeo.register_ids(@video.id, current_user)
    @comment = Comment.new(user: current_user)
    @notes = @video.notes.find_by(user: current_user) || Note.new(noteable: @video)
  end

  private

    def check_unlock
      unless current_user.has_access_to?(@specialty) || current_user.admin
        redirect_to @specialty, alert: 'You have not yet unlocked this specialty'
      end
    end

end
