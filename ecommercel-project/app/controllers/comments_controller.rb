class CommentsController < ApplicationController
  def create
    @comment = Comment.create(comment_params)
    if @comment.invalid?
      flash[:error] = @comment.errors.full_messages
    end
    redirect_to item_path(@comment.item)
  end

  private

  def comment_params
    params.require(:comment).permit(:item_id, :user_id, :author, :text)
  end
end
