class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    today = Date.today
    @first_day = Date.new(today.year, today.month)
    @end_day = Date.new(today.year, today.month, -1)
    @work = Work.new
    @works = Work.all
    @work_today = Work.find_by(day: Date.current)
  end
  
  def edit
    today = Date.today
    @first_day = Date.new(today.year, today.month)
    @end_day = Date.new(today.year, today.month, -1)
    @work = Work.new
  end
  
  def create
    @work_today = Work.find_by(day: Date.current)
    if @work_today.nil?
      @work = Work.new(
        attendance_time: Time.current,
        day: Date.current
      )
    else
      @work = @work_today
      @work.leaving_time = Time.current
    end
    
    if @work.save
      @youbi = %w[日 月 火 水 木 金 土][@work.day.wday]
      flash[:notice] = "#{@work.day.strftime("%-m/%-d")}(#{@youbi}) の勤怠時間を登録しました。"
      redirect_to root_path
    else
      render root_path
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
end
