TrackerDashboard::Application.routes.draw do
  # See how all your routes lay out with "rake routes"

  post   "sessions/create"
  delete "sessions/destroy"
  match  "/signin",  :to => "sessions#create"
  match  "/signout", :to => "sessions#destroy"

  #get    "projects", :to => "projects#index", :as => :projects
  #get    "projects/:id", :to => "projects#show", :as => :project
  #get    "projects/:id/edit", :to => "projects#edit", :as => :edit_project
  #put    "projects/:id", :to => "projects#update", :as => :update_project
  #
  #get    "projects/:id/snapshots", :to => "snapshots#index", :as => :snapshots
  #get    "projects/:id/snapshots/:id", :to => "snapshots#show", :as => :snapshot
  #get    "projects/:id/snapshots/new", :to => "snapshots#new", :as => :new_snapshot

  resources :projects, :only => [:index, :show, :edit, :update] do
    resources :snapshots, :only => [:index, :show, :new] do
    end
  end

  get    "project/show", :to => "projects#index" # This is a friendly redirect from the old scheme to the new scheme

  get    "admin", :to => "admin#index", :as => :admin
  get    "admin/users", :to => "admin#users", :as => :admin_users
  get    "admin/projects", :to => "admin#projects", :as => :admin_projects

  get    "home/index", :to => "home#index", :as => :login
  match  "/login", :to => "home#index"
  root   :to => "home#index"
end
