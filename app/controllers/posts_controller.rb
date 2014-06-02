class PostsController < ApplicationController
  layout :conditional_layout, only: [:index, :show]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  private

    def conditional_layout
      current_user ? 'user_application' : 'application'
    end
end
