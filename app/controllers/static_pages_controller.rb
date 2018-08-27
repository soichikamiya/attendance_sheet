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
    @works = Work.all
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

  def update
    if params[:work_id].nil?
      @work = Work.new(
        attendance_time: params[:attendance_time],
        leaving_time: params[:leaving_time],
        remarks: params[:remarks],
        day: params[:day]
      )
    else
      @work = Work.find(params[:work_id])
      @work.update_attributes(
        :attendance_time => params[:attendance_time],
        :leaving_time => params[:leaving_time],
        :remarks => params[:remarks]
      )
    end

    if @work.save
      flash[:notice] = "勤怠情報を編集しました"
      redirect_to root_path
    else
      render("static_pages/edit")
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
end
