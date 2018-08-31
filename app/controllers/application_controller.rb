class ApplicationController < ActionController::Base
  before_action :set_current_user
  protect_from_forgery with: :exception
  include SessionsHelper
  
  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end
  

  private
    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:notice] = "ログインして下さい"
        redirect_to login_url
      end
    end
end