class UsersController < ApplicationController
  respond_to :js

  def index
  end

  def search
    @users = Search.users params[:username]
  end

  def repos
    @user = User.find(params[:id])
    if @user.nil?
      redirect_to root_path
      flash[:danger] = "Utilisateur github non trouvé"
    end
  end
end
