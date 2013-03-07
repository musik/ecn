Ecn::Application.routes.draw do


  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  #authenticated :user do
    #root :to => 'home#index'
  #end

  devise_for :users
  resources :users, :only => [:show, :index]
  match '/recent'=>"home#recent",:as=>:recent
  match '/popular'=>"home#popular",:as=>:popular
  match '/p-:product_url'=>"home#product",:as=>:product
  match '/c-:company_url'=>"home#company",:as=>:company
  match '/:topic_name/update_count'=>"home#update_count",:as=>:update_count,:via=>:post
  match '/:topic_name'=>"home#topic",:as=>:topic

  root :to => "home#index"
end
