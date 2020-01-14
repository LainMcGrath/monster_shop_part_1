class SessionsController < ApplicationController
  def new
    if current_user != nil
      flash[:notice] = "You are already logged in."
      redirect_to '/profile'
    end
  end

  def create
    if (user = User.find_by(email: params[:email])) && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Hello, #{user.name}. You are now logged in."
      if user.user?
        redirect_to '/profile'
      elsif user.merchant_admin? || user.merchant_employee?
        redirect_to '/merchant'
      elsif user.admin?
        redirect_to '/admin'
      end
    else
      flash[:error] = "Login credentials are incorrect. Please try again."
      render :new
    end
  end

  def destroy
    session.delete(:cart)
    session.delete(:coupon)
    session.delete(:user_id)
    redirect_to "/"
    flash[:notice] = "You have been logged out."
  end
end
