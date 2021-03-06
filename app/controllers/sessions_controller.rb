class SessionsController < ApplicationController

  def create_oauth
    render :root
  end

  def new
    
  end


  def create
    user = User.find_by username: params[:username]
    if user and user.authenticate(params[:password])
      if user.frozen?
        redirect_to :back, notice: "Your account is frozen, please contact admin"
        return
      end
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root, notice: "You have successfully signed out."
  end
end
