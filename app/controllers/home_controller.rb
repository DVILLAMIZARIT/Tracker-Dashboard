class HomeController < ApplicationController
  def index
    if signed_in?
      redirect_to projects_path
      return
    end

  end

end
