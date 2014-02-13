class Admin::VideosController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :js

  protected

  def permitted_params
    params.permit(:video => [:title, :description, :specialty_id, :duration, :vimeo_identifier])
  end

end
