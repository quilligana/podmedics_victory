class Admin::PostsController < ApplicationController
  layout 'admin_application'
  respond_to :html, :json

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def show
  end

  def edit
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    if @post.save
      redirect_to admin_posts_path, notice: 'New Post added'
    else
      render :new
    end
  end

  def update
    if @post.update_attributes(post_params)
      redirect_to admin_post_path(@post), notice: 'Post updated'
    else
      render :edit
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :content, :author_id, :title_image)
    end

    def set_post
      @post = Post.friendly.find(params[:id])
    end

end
