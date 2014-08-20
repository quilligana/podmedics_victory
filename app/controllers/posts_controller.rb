class PostsController < ApplicationController
  layout :conditional_layout, only: [:index, :show]

  def index
    @posts = Post.order(id: :desc)
  end

  def show
    @post = Post.friendly.find(params[:id])

  rescue ActiveRecord::RecordNotFound => e
    redirect_to posts_path, alert: 'Post not found'
  end

  private

    def conditional_layout
      current_user ? 'user_application' : 'application'
    end
end
