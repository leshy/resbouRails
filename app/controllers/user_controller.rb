class UserController < ApplicationController
  def show
    user = User.find_by_id(session[:user_id])
    if user
      render json: user
    else
      render json:  false
    end
  end
end
