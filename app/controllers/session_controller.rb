class SessionController < ApplicationController
  def new
  end
  
  def create
    @user = User.omniauth(env['omniauth.auth'])
    session[:user_id] = @user.id
  end

  def destroy
#    user = User.find_by_id(session[:user_id])
    session[:user_id] = nil
    redirect_to root_url
  end

end
