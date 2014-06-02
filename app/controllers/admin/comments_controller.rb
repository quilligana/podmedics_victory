class Admin::CommentsController < ApplicationController
  layout 'admin_application'

  def index
    @comments = Comment.order(created_at: :desc)
  end

end
