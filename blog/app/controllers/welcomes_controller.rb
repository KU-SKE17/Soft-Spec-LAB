class WelcomesController < ApplicationController
    def index
        @search = params[:search]
        @articles = Article.all.page(params[:page]).order({ updated_at: :desc }).per(25)
    end
end