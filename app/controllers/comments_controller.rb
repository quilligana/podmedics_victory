class CommentsController < ApplicationController

  def create 
    @commentable = find_commentable params
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html #only for replies
        format.js #ajax post, remove for testing
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to comments_url, :notice => "Successfully destroyed comment."
  end

  private

    def find_commentable(params)
      params[:comment][:commentable_type].classify.constantize.friendly.find(params[:comment][:commentable_id])
    end

    def comment_params
      params.require(:comment).permit(:content, :commentable_id, :commentable_type)
    end
end