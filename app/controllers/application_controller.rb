class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize, :login_from_cookie
  
  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else
      @current_user = nil
    end
    @current_user
  end
  
  def signed_in?
    !!current_user
  end
  
  helper_method :current_user, :signed_in? # This makes these methods available in views
  
protected
  
  def login_from_cookie
    unless signed_in?
      id = cookies.signed[:remember_id]
      key = cookies.signed[:remember_key]
      if id and key and user = User.authenticate_from_cookie(id, key)
        session[:user_id] = user.id
      end
    end
  end
  
  # Checks that user is logged in
  def authorize
    redirect_to show_login_path, :alert => t('.need_to_be_logged_in') unless signed_in?
  end
  
  def require_signed_out
    redirect_to invoices_path, :alert => t('.already_signed_in') if signed_in?
  end
  
  # TODO: This method should blackhole if the user is not signed in as well.
  def require_admin
    if signed_in? and !current_user.admin?
      # Blackhole the request in production env
      blackhole
    elsif not signed_in?
      redirect_to show_login_path, :alert => t('.need_to_be_logged_in') unless signed_in? and current_user.admin?
    end
  end
  
  # Blackholes request only if on production. If on development or test, shows an :alert
  def blackhole
    if Rails.env.production?
      not_found
    else
      #flash[:alert] = 'This request was blackholed!'
      #logger.info "Request blackholed"
      redirect_to show_login_path, :alert => 'Request was blackholed!'
    end
  end
  
  def blackhole!
    not_found
  end
  
  def not_found
    render(:file => "#{Rails.root.to_s}/public/404.html", :layout => false, :status => 404)
  end
end
