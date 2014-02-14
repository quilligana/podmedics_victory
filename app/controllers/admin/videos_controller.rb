class Admin::VideosController < InheritedResources::Base
  layout 'admin_application'
  before_action :authenticate_admin


  def create
    create!(notice: 'New video added') { admin_videos_path }
  end

  def update
    update!(notice: 'Video updated') { admin_videos_path }
  end


  def permitted_params
    params.permit(:video => [:title, :description, :specialty_id, :vimeo_identifier, :duration])
  end

end
