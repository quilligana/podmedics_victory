class Admin::PostsController < InheritedResources::Base
  layout 'admin_application'
  respond_to :html, :json

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def permitted_params
    params.permit(:post => [:title, :content, :author_id, :title_image])
  end

  private

    def set_post
      @post = Post.friendly.find(params[:id])
    end

end
