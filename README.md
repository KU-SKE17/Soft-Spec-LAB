# Ruby on rails

## Table of Contents

1. [Basic](#basic)
2. [Routes](#routes)
3. [Database](#database)
4. [Console](#console)
5. [Model](#model)
6. [Subclass](#subclass)
7. [Authentication](#authentication)
8. [Testing](#testing-and-debugging)
9. [UI](#ui)
10. [Function](#function)
11. [Caching](#caching)
12. [Enum](#enum)
13. [CSV](#csv)
14. [App Constant](#app-constant)
15. [Active Storage](#active-storage)
16. [API](#api)

## Basic

### create project name ‘blog’

    rails new blog

### run server

    rails s

### update Gemfile

    bundle install

### show all routes

    rails routes

note. rails routes -c `controller_name`

note. `link` use in `slim` = `###_path` [ดูแล้วเติม_path]

## Routes

config/routes.rb

```ruby
Rails.application.routes.draw do
    # home page
    root 'articles#index'
    # others page
    get "/articles", to: "articles#index"
end
```

### generate controller

    rails generate controller Articles index

## Database

### create file for database name ‘…\_create_article’

    rails g migration CreateArticle

### create database (create schema.rb)

    rails db:migrate

in app/models

### drop database

    rails db:drop:_unsafe

### reset database (not update Schema)

    rake db:reset

Create class Article < ApplicationRecord

### run db/seed.rb

    rails db:seed

## Console

### run in console

    rails c

or

    irb

```irb
Article.new
Article.create(title: “Article B”, body: “Another Article”)

Article.all
Article.where(title: ’This is ’) # array
Article.find_by # obj
Article.first
Article.second
Article.last

Article.count
a.attribute
# print `a` attributes line by line
pp a

# &: => a func
# call `func` for every articles
Article.all.map(&:save)

# reload console
reload!
```

### use rbenv

    rbenv init

## Model

### generate model

    rails generate model Article title:string body:text

```ruby
class Article < ApplicationRecord

    has_many :comments

    # validates -> rails own check
    validates :body, length: { minimum: 4 }
    # validate -> your own check
    validate :no_bad_words_in_title

    # nomal function
    def say_hello
        # return 'Hello'
        'Hello'
    end

    # validate function
    def no_bad_words_in_title
        if title.downcase.include?('bad')
            # throw error
            errors.add(:title, 'cannot contain bad words')
        end
    end
end
```

### display error on web page

```slim
<% flash[:error]&.join(', ') %>
```

`&` = check ว่ามี errorไม

## Subclass

### [1-to-many]

if Article has many comments

article.rb

```ruby
class Article < ApplicationRecord

    has_many :comments, dependent: :destroy
```

note. `dependent: :destroy` -> when article destroyed, its comments are also destroyed.

comment.rb

```ruby
class Comment < ApplicationRecord

    belongs_to :article
```

note. `belongs_to :article` -> Comment, itself can edit the article it belong to. for example function `change_article_title`

comment.rb

```ruby
class Comment < ApplicationRecord

    belongs_to :article
    before_destory :change_article_title

    def change_article_title
        article.title = "#{article.title} X"
    end
```

### [many-to-many]

if Category has many articles and Article has many categories

article.rb

```ruby
class Article < ApplicationRecord

    has_many :article_categories
    has_many :categories, through: :article_categories
```

category.rb

```ruby
class Category < ApplicationRecord

    has_many :article_categories
    has_many :articles, through: :article_categories
```

article_category.rb

```ruby
class ArticleCategory < ApplicationRecord

    belongs_to :article
    belongs_to :category
```

note. migrate file of `ArticleCategory` need to follow:

db/migrate/xxxxxxxx_create_article_category.rb

```ruby
class CreateArticleCategory < ActiveRecord::Migration[6.1]

    def change
        create_table :article_categories do |t|
            t.belongs_to :article
            t.belongs_to :category

            t.timestamps
        end
    end
```

index.slim

```slim
a.categories.map(&:name)&.join(', ').presence || 'NA'
```

### Category editer (admin)

ApplicationController.rb

```ruby
def article_params
    # add `category_id: []`
    params.require(:article).permit(:title, :body, category_id: [])
end
```

\_form.slim

```slim
div Category
/model that article has `(category)_ids`
div = f.collection_check_boxes :category_ids, Category.all, :id, :name do |b|
    div
        span = b.check_box
        span = b.label
```

## Authentication

### add bunde authentication

    rails generate devise:install

### generate Admin

    rails generate devise Admin

### use Admin

ApplicationController.rb

```ruby
# add to check before redirect to page
before_action :authenticate_admin!
```

index.slim

- to call admin data

```slim
div = current_admin.email
div = "#{current_admin.firstname} #{current_admin.lastname}"
```

- to logout

```slim
div = link_to 'Logout', destroy_admin_session_path, method: :delete
```

note. ถ้าไม่ใส่ `method:` จะเป็น GET เสมอ

## Testing and Debugging

### add bundes

```
group :development, :test do
    # For debugging
    gem 'pry', '~> 0.13.1'
    # For testing
    gem 'rspec-rails', '~> 4.0.2'
    # ...
```

### generate spec (testing)

    rails generate rspec:install

### create test for a model

    rails generate rspec:model [MODEL_NAME]

for model `admin` -> `rails g rspec:model admin`

### run Test

Run all spec files

    bundle exec rspec

### test File

admin_spec.rb

```ruby
# describe -> method name
describe "email_cannot_have_bob" do
    # context -> tell test by set up ...
    context "emails contains bob" do
        # it -> text display when error
        it "is invalid to have bob in email" do
            admin = Admin.new(email: 'bob@gmail.com', password: '111111')
            # check to error
            # if true -> pass, false -> error
            expect(admin.valid?).to eq(false)
        end
    end

    # re-check another way
    context "emails does not contain bob" do
        it "is valid not to have bob in email" do
            admin = Admin.new(email: 'beb@gmail.com', password: '111111')
            expect(admin.valid?).to eq(true)
        end
    end
end

```

### debugging

ApplicationController.rb

```ruby
def index
        # ...
        # add
        binding.pry
    end
```

then run server!

note. when load page, the page will freeze and the console log will start the `rails c` at that part.

So you can type `ls` to see currant data or just the `variable name` to see what is it.

## UI

### Bootstrap & FontAwesome (icon)

app/views/layouts/application.html.erb

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Blog</title>
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <%= csrf_meta_tags %> <%= csp_meta_tag %>
    <!DOCTYPE html>
    <html>
      <head>
        <title>Blog</title>
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <%= csrf_meta_tags %> <%= csp_meta_tag %> <%= stylesheet_link_tag
        'application', media: 'all', 'data-turbolinks-track': 'reload' %> <%=
        stylesheet_link_tag
        'https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css'
        %> <%= stylesheet_link_tag
        'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css'
        %> <%= javascript_pack_tag 'application', 'data-turbolinks-track':
        'reload' %>
      </head>

      <body>
        <div class="container">
          <h1 style="color: red;"><%= flash[:error]&.join(',') %></h1>
          <%= yield %> <%= javascript_include_tag
          'https://code.jquery.com/jquery-3.2.1.slim.min.js' %> <%=
          javascript_include_tag
          'https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js'
          %> <%= javascript_include_tag
          'https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js'
          %>
        </div>
      </body>
    </html>

    <%= stylesheet_link_tag 'application', media: 'all',
    'data-turbolinks-track': 'reload' %> <%= stylesheet_link_tag
    'https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' %>
    <%= stylesheet_link_tag
    'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css'
    %> <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload'
    %>
  </head>

  <body>
    <div class="container">
      <h1 style="color: red;"><%= flash[:error]&.join(',') %></h1>
      <%= yield %> <%= javascript_include_tag
      'https://code.jquery.com/jquery-3.2.1.slim.min.js' %> <%=
      javascript_include_tag
      'https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js'
      %> <%= javascript_include_tag
      'https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js' %>
    </div>
  </body>
</html>
```

index.slim

```slim
.row
    .col-6
        h1 This is articles list
    .col-6
        .float-right
            span = current_admin.email
            span.ml-3 = "#{current_admin.firstname} #{current_admin.lastname}"
            span.ml-3 = link_to 'Logout', destroy_admin_session_path, method: :delete

.row
    .col
        = form_tag articles_path, method: :get do
            = text_field_tag 'search', @search, placeholder: 'Type something', class: 'form-control'

.row.mt-2
    .col
        table.table.table-bordered.table-striped
            thead.thead-dark
                tr
                    th ID
                    th Title
                    th Body
                    th No. Comments
                    th Created at
                    th Updated at
                    th Action
            tbody
                - @articles.each do |a|
                    tr.hoverable-row
                        td = a.id
                        td.font-weight-bold = a.title
                        td = a.body
                        td = a.comments.count
                        td.font-weight-light = "#{time_ago_in_words(a.created_at)} ago"
                        td.font-weight-light = "#{time_ago_in_words(a.updated_at)} ago"
                        td
                            span
                                = link_to article_path(a) do
                                    i.fas.fa-eye
                            span.ml-3
                                = link_to edit_article_path(a) do
                                    i.fas.fa-pen
                            span.ml-3
                                = link_to article_path(a), method: :delete, data: { confirm: "Are you sure?" } do
                                    i.fas.fa-trash

.row
    .col-6
        = paginate @articles
    .col-6
        .float-right
            = link_to new_article_path do
                = button_tag 'Add new Article', class: 'btn btn-primary'
```

### Kaminari (pagination)

Gemfile

```
gem 'kaminari'
```

Terminal

    <!-- check themes -->
    rails generate kaminari:views THEME

    <!-- choose theme -->
    rails generate kaminari:views bootstrap4

index.slim

```slim
= paginate @articles
```

## Function

### search

index.slim

```slim
= form_tag root_path, method: :get do
    = text_field_tag 'search', @search, placeholder: 'Type something', class: 'form-control'
```

ApplicationController.rb

```ruby
def index
    @search = params[:search]
    @items = Item.all
    @items = @items.where("title like ? or description like ?", "%#{@search}%", "%#{@search}%") if @search.present?
    @items = @items.page(params[:page]).per(5)
end
```

## Caching

Gemfile

```
# page caching
gem 'actionpack-page_caching'
# action caching
gem 'actionpack-action_caching'
```

ApplicationController.rb

```ruby
class ArticlesController < ApplicationController
    # add
    caches_page :index
    caches_action :index
```

### open/close caching

    rails dev:cache

### cache only rows (not the whole page)

index.slim

```slim
- @articles.each do |a|
    <!-- add -->
    - cache a do
        tr.hoverable-row
            td = a.id
            td.font-weight-bold = a.title
            td = a.body
            ...
```

## Enum

### add attribute to a model

    rails g migration AddStatusToArticle

```ruby
class AddStatusToArticle < ActiveRecord::Migration[6.1]
    def change
        add_column :articles, :status, :integer, null: false, default: 0
    end
end
```

### define emun to model

```ruby
class Article < ApplicationRecord
    enum status: { draft: 0, published: 1, archived: 2 }
```

note. in console

```irb
# ask is its a draft?
a.draft?
# ask what is its status?
a.status
# asign it to be a draft.
update a.draft!
```

## CSV

### Download CSV

index.slim

```slim
<!-- add -->
= link_to articles_path(format: :csv) do
    = button_tag 'Download CSV', class: 'btn btn-secondary float-right'
```

ApplicationController.rb

```ruby
def index
    ...
    # add
    respond_to do |format|
        format.html
        format.csv { send_data generate_csv(Article.all), file_name: 'articles.csv' }
    end
end

...

private

# add
def generate_csv(articles)
    articles.map { |a| [a.title, a.body, a.created_at.to_date].join(',') }.join("\n")
end
```

### Upload CSV

config/routes.rb

```ruby
# add
namespace :articles do
    post 'csv_upload'
end
```

index.slim

```slim
<!-- add -->
= form_tag articles_csv_upload_path, multipart: true do
    div = file_field_tag :csv_file
    div = submit_tag :upload
```

ApplicationController.rb

```ruby
# add
def csv_upload
    data = params[:csv_file].read.split("\n")
    data.each do |line|
        attr = line.split(",").map(&:strip)
        Article.create title: attr[0], body: attr[1]
    end
    redirect_to action: :index
end
```

## App Constant

### create file constant.rb

ประกาศ constant ใน `config/initializers/xxx.rb` จะใช้ได้ทุกที่ (controller, console, views, ...)

config/initializers/contant.rb

```ruby
CONSTANT_A = 'A'
CONSTANT_B = 'B'
```

note. everything in `/initializers` will be call on system (server) startup

### create file yml

config/shipping_fees.yml

```yml
bangkok:
  silom: 100
  sahorn: 120
  # smyan:
  #     - a
  #     - b
  #     - c
chiangmai:
  xxx: 700
trang:
  yyy: 300
  zzz: 350
```

config/initializers/shipping_fees.rb

```ruby
SHIPPING_FEES = YAML.load_file(Rails.root.join('config/shipping_fees.yml'))
```

## Active Storage

    rails active_storage:install
    rails db:migrate

config/storage.yml
[แค่ให้ดูเฉยๆ]

models/article.rb

```ruby
# add
has_one_attached :cover_image
# has_many_attached :images

# a = Article.first
# a.cover_image.attached? => false
```

controllers/articles_controller.rb

```ruby
def article_params
    # add 'cover_image' before all {}
    params.require(:article).permit(:title, :body, :cover_image, category_id: [])
    # params.require(:article).permit(:title, :body, :cover_image, category_id: [], images: [])
end
```

views/articles/\_form.slim

```slim
<!-- add -->
div Cover Image
div = f.file_field :cover_image
```

views/articles/index.slim

```slim
<!-- change -->
td = a.id

<!-- to -->
td
    - if a.cover_image.attached?
        = image_tag a.cover_image, width: '64px'
```

### `ที่ทำมาจนถึงตรงนี่ใช้ได้... แต่!! จะหายไปถ้าreserver!`

### solution

config/storage.yml

```yml
# enable
amazon:
  service: S3
  access_key_id: <%= Rails.application.credentials.dig(:aws, :access_key_id) %>
  secret_access_key: <%= Rails.application.credentials.dig(:aws, :secret_access_key) %>
  region: us-east-1
  bucket: your_own_bucket
```

example

```yml
amazon:
  service: S3
  access_key_id: AKIAVERVDS3NM3H6UZVL
  secret_access_key: J98Wu6+3kCTiJbIOaSIDd2JBCnrY79LZO16HruXW
  region: ap-southeast-1
  bucket: ssd-2021
```

config/environments/ `development.rb` and `production.rb`

```ruby
# change both!
config.active_storage.service = :amazon
```

Gemfile

```
# upload file to AWS S3
gem 'aws-sdk-s3'
```

### `แต่นี้ก้คือวิธีที่ผิดอยู่ดี วิธีที่ถูกคือ...`

config/storage.yml

```yml
amazon:
  service: S3
  <!-- change -->
  access_key_id: <%= ENV['AWS_ACCESS_KEY'] %>
  secret_access_key: <%= ENV['AWS_KEY_ID'] %>
  region: ap-southeast-1
  bucket: ssd-2021
```

config/environments/production.rb

```ruby
# change
config.active_storage.service = :amazon
```

in Heroku -> Setting -> Config Vars

add `AWS_ACCESS_KEY` and `AWS_KEY_ID`

## API

### create api

create api/v1/CommentsController.rb

```ruby
class Api::V1::CommentsController < ApplicationController
  def index
    @comments = Article.find(params[:article_id]).comments

    # Not optimal, but get the job done
    # http://0.0.0.0:3000/api/v1/articles/1003/comments
    render json: @comments
  end
end
```

routes.rb

```ruby
    # add
    namespace :api do
        namespace :v1 do
            resources :articles, only: [] do
                resources :comments, only: :index
            end
        end
    end
```

### use api

create app/javascript/blog/comments.js

```js
(function () {
  document.addEventListener("turbolinks:load", function () {
    let commentButtons = document.getElementsByClassName("btn-comment");

    Array.from(commentButtons).forEach(function (button) {
      button.addEventListener("click", function () {
        loadComments(this.getAttribute("article"));
      });
    });

    function loadComments(articleId) {
      let host = window.location.protocol + "//" + window.location.host;
      // url = host + protocol + path
      let url = host + "/api/v1/articles/" + articleId + "/comments";
      let http = new XMLHttpRequest();

      http.onreadystatechange = function () {
        if (http.readyState == XMLHttpRequest.DONE) {
          if (http.status == 200) {
            let comments = JSON.parse(http.responseText);
            let commentsView = document.getElementById("comments-" + articleId);
            commentsView.innerHTML = "";

            comments.forEach(function (comment) {
              let commentsRow = document.createElement("div");
              commentsRow.innerHTML = comment.author + " : " + comment.text;
              commentsView.append(commentsRow);
            });
          } else {
            console.log("The Request failed.");
          }
        }
      };
      http.open("GET", url);
      http.send();
    }
  });
})();
```

app/javascript/packs/application.js

```js
// add
require("blog/comments");
```
