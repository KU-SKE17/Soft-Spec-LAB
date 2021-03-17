# Ruby on rails

## Table of Contents

1. [Basic](#basic)
2. [Routes](#routes)
3. [Database](#database)
4. [Console](#console)
5. [Model](#model)
6. [Authentication](#authentication)
7. [Testing](#testing-and-debugging)
8. [UI](#ui)
9. [Function](#function)

## Basic

### create project name ‘blog’

    rails new blog

### run server

    rails s

### update Gemfile

    bundle install

### show all routes

    rails routes

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

    bin/rails generate controller Articles index

## Database

### create file for database name ‘…\_create_article’

    rails g migration CreateArticle

### create database (create schema.rb)

    rails db:migrate

in app/models

Create class Article < ApplicationRecord

## Console

### run in console

    rails c

or

    irb

```irb
Article.new
Article.create(title: “Article B”, body: “Another Article”)
Article.count
Article.first
Article.second
…
Article.last
Article.where(title: ’This is ’)
Article.all
a.attribute
```

### use rbenv

    rbenv init

## Model

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

### generate model

    bin/rails generate model Article title:string body:text

### display error on web page

```slim
<% flash[:error]&.join(', ') %>
```

`&` = check ว่ามี errorไม

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
    bin/rails generate kaminari:views THEME

    <!-- choose theme -->
    bin/rails generate kaminari:views bootstrap4

index.slim

```slim
= paginate @articles
```

## Function

#search