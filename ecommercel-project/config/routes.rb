Rails.application.routes.draw do

  get 'comments/index'
    devise_for :users, :controllers => {:registrations => "registrations"}
    root 'welcomes#index'
    get 'welcomes/:id', to: 'welcomes#show'
    resources :welcomes
  resources :comments

    scope '/admin' do
        resources :items, :categories, :users, :orders
        namespace :items do
            post 'csv_upload'
        end
        delete 'items/del_main_image/:id', to: 'items#del_main_image'
        delete 'items/del_support_images/:id', to: 'items#del_support_images'

        get 'users/switch_role/:id', to: 'users#switch_role'
        delete 'users/delete/:id', to: 'users#destroy'
    end
end
