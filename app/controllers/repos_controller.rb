class ReposController < ApplicationController
  respond_to :js

  def details
    @repo = Repo.find(params[:user_id], params[:id])
    @user = params[:user_id]
  end

end
