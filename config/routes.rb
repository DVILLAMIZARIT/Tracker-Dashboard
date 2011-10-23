TrackerDashboard::Application.routes.draw do
  # See how all your routes lay out with "rake routes"

  post   "sessions/create"
  delete "sessions/destroy"
  match  "/signin",  :to => "sessions#create"
  match  "/signout", :to => "sessions#destroy"

  resources :projects, :only => [:index, :show, :edit, :update] do
    resources :snapshots, :only => [:index, :show, :new]
  end
  get    "/projects/:id/red_flags/edit",   :to => "red_flags#edit",   :as => :edit_project_red_flags
  put    "/projects/:id/red_flags/update", :to => "red_flags#update", :as => :update_project_red_flags

  get    "project/show", :to => "projects#index" # This is a friendly redirect from the old scheme to the new scheme

  get    "admin", :to => "admin#index", :as => :admin
  get    "admin/users", :to => "admin#users", :as => :admin_users
  get    "admin/projects", :to => "admin#projects", :as => :admin_projects

  get    "home/index", :to => "home#index", :as => :login
  match  "/login", :to => "home#index"
  root   :to => "home#index"
end
