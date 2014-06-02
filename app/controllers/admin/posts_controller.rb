class Admin::PostsController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :json

  def permitted_params
    params.permit(:post => [:title, :content, :author_id, :title_image])
  end

end
