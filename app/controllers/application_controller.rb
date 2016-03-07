class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user  

  def current_user
   return nil if session[:user_id].nil?
   User.find(session[:user_id])
  end
  
  def ensure_that_signed_in
    redirect_to signin_path, notice:'You should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    ensure_that_signed_in
    redirect_to :signin_path, notice:'You have to be server admin' if not current_user.admin
  end

  def order_helper(list, order, desc)

    sorted = case order
      when 'name' then list.sort_by{ |obj| obj.name }
      when 'year' then list.sort_by{ |obj| obj.year }
      when 'style' then list.sort_by{ |obj| obj.style }
      when 'brewery' then list.sort_by{ |obj| obj.brewery.name}
    end
    
    return sorted.reverse if desc
    return sorted
  end

end
