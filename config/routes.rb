Ecn::Application.routes.draw do


  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  #authenticated :user do
    #root :to => 'home#index'
  #end

  devise_for :users
  resources :users, :only => [:show, :index]
  match '/recent'=>"home#recent",:as=>:recent
  match '/popular'=>"home#popular",:as=>:popular
  match '/search'=>"home#search",:as=>:search
  match '/archive/:day'=>"home#day",:as=>:day
  match '/archive'=>"home#archive",:as=>:archive
  match '/test'=>"home#test",:as=>:test
  match '/p-:product_url'=>"home#product",:as=>:product
  match '/c-:company_url'=>"home#company",:as=>:company

  resque_constraint = lambda do |request|
    Rails.env.development? or 
      (request.env['warden'].authenticate? and request.env['warden'].user.has_role?(:admin))
  end
  constraints resque_constraint do
    mount Resque::Server.new, :at => "/resque"
  end
  match '/:topic_name/update_count'=>"home#update_count",:as=>:update_count,:via=>:post
  match '/status'=>"home#status",:as=>:status
  match '/:topic_name'=>"home#topic",:as=>:topic
  root :to => "home#index"
end
