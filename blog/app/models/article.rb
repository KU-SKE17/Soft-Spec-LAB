class Article < ApplicationRecord
    enum status: { draft: 0, published: 1, archived: 2 }
    # ask a.draft?
    # ask a.status
    # update a.draft!

    scope :long_title, -> (length = 15) { where('LENGTH(title) > ?', length) }
    scope :short_body, -> (length = 7) { where('LENGTH(title) < ?', length) }
    scope :search , -> (keyword) { where("title like ? or body like ?", "%#{keyword}%",  "%#{keyword}%") }

    has_one_attached :cover_image
    has_many_attached :images

    has_many :comments, dependent: :destroy
    has_many :article_categories
    has_many :categories, through: :article_categories

    # validates -> rails own check
    validates :title, :body, polite: true
    validates :body, length: { minimum: 4 }
    # validate -> my own check
    # validate :no_bad_words_in_title

    before_save :clean_data

    # def no_bad_words_in_title
    #     if title.downcase.include?('bad')
    #         errors.add(:title, 'cannot contain bad words')
    #     end
    # end

    def clean_data
        self.title = title.upcase.squish
        self.body = body.humanize
    end

    def test_atomic_function
        Article.transaction do
            update title: "Atomic part A"
            # Complicated code start
            raise "Something dose wrong"
            # Complicated code end
            update title: "Atomic part B"
        end
    end
end