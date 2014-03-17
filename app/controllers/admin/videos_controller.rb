class Admin::VideosController < InheritedResources::Base
  layout 'admin_application'

  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def create
    create!(notice: 'New video added') { admin_videos_path }
  end

  def update
    update!(notice: 'Video updated') { admin_videos_path }
  end


  def permitted_params
    params.permit(:video => [:title, :description, :specialty_id, :vimeo_identifier, :duration, :preview])
  end

  private

    def set_video
      @video = Video.friendly.find(params[:id])
    end

end
