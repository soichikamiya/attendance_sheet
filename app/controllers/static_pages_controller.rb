class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    today = Date.today
    @first_day = Date.new(today.year, today.month)
    @end_day = Date.new(today.year, today.month, -1)
  end
  
  def edit
    today = Date.today
    @first_day = Date.new(today.year, today.month)
    @end_day = Date.new(today.year, today.month, -1)
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
end
