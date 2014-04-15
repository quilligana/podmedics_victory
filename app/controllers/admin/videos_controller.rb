class Admin::VideosController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :json

  before_action :set_video, only: [:show, :edit, :update, :destroy, :move_up, :move_down]

  def create
    create!(notice: 'New video added') { admin_videos_path }
  end

  def update
    update!(notice: 'Video updated') { admin_videos_path }
  end

  def permitted_params
    params.permit(:video => [:title, :description, :specialty_id, :vimeo_identifier, :duration, :preview, :file_name, :speaker_name, :position, :author_id])
  end

  def move_up
    @video.move_higher
    redirect_to admin_specialty_path(@video.specialty)
  end

  def move_down
    @video.move_lower
    redirect_to admin_specialty_path(@video.specialty)
  end

  protected

    def collection
      @videos ||= end_of_association_chain.includes(:specialty).order(:title)
    end

  private

    def set_video
      @video = Video.friendly.find(params[:id])
    end

end
