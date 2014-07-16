class Admin::VideosController < ApplicationController
  layout 'admin_application'
  respond_to :html, :json

  before_action :set_video, only: [:show, :edit, :update, :destroy, :move_up, :move_down, 
                                   :send_notifications, :send_test_notifications, :mark_proofread]

  def index
    @videos = Video.includes(:specialty, :tags, :author).order(:title).paginate(page: params[:page])
    
  end

  def show
  end

  def new
    @video = Video.new
  end

  def edit
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      redirect_to admin_video_path(@video), notice: 'New video added'
    else
      render :new
    end
  end

  def update
    if @video.update_attributes(video_params)
      redirect_to admin_video_path(@video), notice: 'Video updated'
    else
      render :edit
    end
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

  private

    def video_params
      params.require(:video).permit(:title, :description, :specialty_id, :vimeo_identifier, :duration, :preview, :file_name, :speaker_name, :position, :author_id, :tag_list, :proofread)
    end

    def set_video
      @video = Video.friendly.find(params[:id])
    end

end
