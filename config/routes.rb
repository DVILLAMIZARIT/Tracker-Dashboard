TrackerDashboard::Application.routes.draw do
  # See how all your routes lay out with "rake routes"

  post   "sessions/create"
  delete "sessions/destroy"
  match  "/signin",  :to => "sessions#create"
  match  "/signout", :to => "sessions#destroy"

  resources :projects, :only => [:index, :show] do
    resources :snapshots, :only => [:index, :show, :new]
  end
  get    "/projects/:id/red_flags",   :to => "red_flags#show",   :as => :project_red_flags
  get    "/projects/:id/red_flags/edit",   :to => "red_flags#edit",   :as => :edit_project_red_flags
  put    "/projects/:id/red_flags/update", :to => "red_flags#update", :as => :update_project_red_flags
  get    "/projects/:id/tracks",   :to => "tracks#show",   :as => :project_tracks
  get    "/projects/:id/tracks/edit",   :to => "tracks#edit",   :as => :edit_project_tracks
  put    "/projects/:id/tracks/update", :to => "tracks#update", :as => :update_project_tracks

  get    "project/show", :to => "projects#index" # This is a friendly redirect from the old scheme to the new scheme

  get    "admin", :to => "admin#index", :as => :admin
  get    "admin/users", :to => "admin#users", :as => :admin_users
  get    "admin/projects", :to => "admin#projects", :as => :admin_projects
  get    "admin/cache_clear", :to => "admin#cache_clear", :as => :admin_cache_clear

  get    "home/index", :to => "home#index", :as => :login
  match  "/login", :to => "home#index"
  root   :to => "home#index"
end
