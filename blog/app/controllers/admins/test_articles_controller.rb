class Admins::TestArticlesController < ApplicationController
    caches_page :index
    # caches_action :index

    def index
        @articles = Article.all
    end
end
