# Ruby on rails

## Table of Contents

1. [Basic](#basic)
2. [Database](#database)
3. [Console](#console)
4. [Authentication](#authentication)
5. [Testing](#testing)

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

## Database

### create file for database name ‘…\_create_article’

    rails g migration CreateArticle

### create database (create schema.rb)

    rails db:migrate

in models
Create class Article < ApplicationRecord

## Console

### run in console

    rails -c

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

<% flash[:error]&.join(', ') %>

`&` = check ว่ามี errorไม

### use rbenv

    rbenv init

## Authentication

### Add bunde authentication

    rails generate devise:install

### Generate Admin

    rails generate devise Admin

### Use Admin

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

note. `method:` ถ้าไม่ใส่ จะเป็น GET เสมอ

## Testing

### Add bunde Testing

    group :development, :test do
    # For testing
    gem 'rspec-rails', '~> 4.0.2'

### Generate spec (testing)

    rails generate rspec:install

### Create test for a model

    rails generate rspec:model [MODEL_NAME]

for model `admin` -> `rails g rspec:model admin`

### Run Test

Run all spec files

    bundle exec rspec

### Test File

In

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
