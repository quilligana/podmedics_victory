class Admin::CommentsController < ApplicationController
  layout 'admin_application'

  def index
    @comments = Comment.includes(:commentable).order(:id)
  end

end
