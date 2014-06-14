class Admin::VideosController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :json

  before_action :set_video, only: [:show, :edit, :update, :destroy, :move_up, :move_down, 
                                   :send_notifications, :send_test_notifications, :mark_proofread]

  def create
    create!(notice: 'New video added') { admin_videos_path }
  end

  def update
    update!(notice: 'Video updated') { admin_videos_path }
  end

  def permitted_params
    params.permit(:video => [:title, :description, :specialty_id, :vimeo_identifier, :duration, :preview, :file_name, :speaker_name, :position, :author_id, :tag_list])
  end

  def move_up
    @video.move_higher
    redirect_to admin_specialty_path(@video.specialty)
  end

  def move_down
    @video.move_lower
    redirect_to admin_specialty_path(@video.specialty)
  end

  def send_notifications
    @video.send_video_notification
    redirect_to :back
  end

  def send_test_notifications
    @video.send_test_notification
    redirect_to :back, notice: 'New episode test email sending'
  end

  def mark_proofread
    @video.mark_proofread
    redirect_to :back, notice: 'Video marked as proofread'
  end

  protected

    def collection
      @videos ||= end_of_association_chain.includes(:specialty).order(:title).paginate(page: params[:page])
    end

  private

    def set_video
      @video = Video.friendly.find(params[:id])
    end

end
