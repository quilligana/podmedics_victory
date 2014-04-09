class CommentsController < ApplicationController

  def create
    @commentable = find_commentable params

    if params[:comment][:commentable_type] == "SpecialtyQuestion"
      @comment = @commentable.answers.new(comment_params)
    else
      @comment = @commentable.comments.new(comment_params)
    end


    @comment.user = current_user

    if @comment.commentable_type == "Comment"
      @comment.root = @comment.commentable.root
    else
      @comment.root = @comment.commentable
    end

    unless @comment.save
      @comment = nil
    end

    respond_to do |format|
      format.html #only for replies
      format.js #ajax post, remove for testing
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to comments_url, :notice => "Successfully destroyed comment."
  end

  private

    def find_commentable(params)
      if params[:comment][:commentable_type] == "Video"
        params[:comment][:commentable_type].classify.constantize.friendly.find(params[:comment][:commentable_id])
      else
        params[:comment][:commentable_type].classify.constantize.find(params[:comment][:commentable_id])
      end
    end

    def comment_params
      params.require(:comment).permit(:content, :commentable_id, :commentable_type)
    end
end