class Admin::VideosController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :json

  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def create
    create!(notice: 'New video added') { admin_videos_path }
  end

  def update
    update!(notice: 'Video updated') { admin_videos_path }
  end

  def import
    Video.import(params[:file])
    redirect_to admin_videos_path, notice: 'Videos imported'
  end

  def permitted_params
    params.permit(:video => [:title, :description, :specialty_id, :vimeo_identifier, :duration, :preview, :file_name, :speaker_name])
  end

  protected

    def collection
      @videos ||= end_of_association_chain.order(:title)
    end

  private

    def set_video
      @video = Video.friendly.find(params[:id])
    end

end
