TrackerDashboard::Application.routes.draw do
  # See how all your routes lay out with "rake routes"

  post   "sessions/create"
  delete "sessions/destroy"
  match  "/signin",  :to => "sessions#create"
  match  "/signout", :to => "sessions#destroy"

  get    "projects/index", :as => :projects

  get    "projects/show/:id", :to => "projects#show", :as => :project

  get    "project/show", :to => "projects#index"

  get    "home/index", :as => :login
  root   :to => "home#index"
end
