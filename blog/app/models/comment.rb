class Comment < ApplicationRecord
    belongs_to :article

    before_destroy :change_article_title

    def change_article_title
        article.title = "#{article.title} X"
    end
end