class Api::V1::CommentsController < ApplicationController
  def index
    @comments = Article.find(params[:article_id]).comments

    # Not optimal, but get the job done
    # http://0.0.0.0:3000/api/v1/articles/1003/comments
    render json: @comments
  end
end