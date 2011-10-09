TrackerDashboard::Application.routes.draw do
  # See how all your routes lay out with "rake routes"

  post   "sessions/create"
  delete "sessions/destroy"
  match  "/signin",  :to => "sessions#create"
  match  "/signout", :to => "sessions#destroy"

  get    "projects", :to => "projects#index", :as => :projects

  get    "projects/:id", :to => "projects#show", :as => :project

  get    "projects/:id/edit", :to => "projects#edit", :as => :edit_project

  get    "project/show", :to => "projects#index" # This is a friendly redirect from the old scheme to the new scheme

  get    "home/index", :to => "home#index", :as => :login
  match  "/login", :to => "home#index"
  root   :to => "home#index"
end
