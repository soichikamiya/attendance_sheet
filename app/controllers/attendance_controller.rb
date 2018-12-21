class AttendanceController < ApplicationController
  before_action :logged_in_user
  before_action :set_user
  before_action :ensure_correct_user, {only:[:attendance, :edit, :create, :select_time, :select]}
  
  def attendance
    today = Date.today
    @user = User.find_by(id: params[:id])
    
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      @first_day = Date.new(today.year, today.month, 1)
    end
    @end_day = @first_day.end_of_month
    
    #@first_day = Date.new(today.year, today.month)
    #@end_day = Date.new(today.year, today.month, -1)
    @work = Work.new
    @works = Work.all
    @work_today = Work.where("day IN (?) AND user_id IN (?)", Date.current, @user.id).first
    @work_all_time, @a_all, @l_all, @youbi_sum = [],[],[],[]
    
    @a_edit = Work.where("attendance_time_edit like '%" + ":" + "%'")
    @l_edit = Work.where("leaving_time_edit like '%" + ":" + "%'")
    @a_edit.each { |w| @a_edit = w.attendance_time_edit }
    @l_edit.each { |w| @l_edit = w.leaving_time_edit }
    
    (@first_day..@end_day).each { |d| @youbi_sum << [d.wday] }
    @work_youbi = @youbi_sum.flatten.count { |a| a != 0 && a != 6 }
    
    (@first_day..@end_day).each do |date|
      # 該当日付のデータがないなら作成する
      if !@user.works.any? {|work| work.day == date }
        work = Work.create(user_id: @user.id, day: date)
        work.save
      end
    end
  end
  
  def edit
    today = Date.today
    @user = User.find_by(id: params[:id])
    @first_day = Date.new(today.year, today.month)
    @end_day = Date.new(today.year, today.month, -1)
    @work = Work.new
    @works = Work.all
  end
  
  def create
    @user = User.find_by(id: params[:id])
    @work_today = @user.works.find_by(day: Date.current)
    if @work_today.nil?
      @work = Work.new(
        attendance_time: Time.current,
        day: Date.current,
        user_id: params[:id]
      )
    elsif @work_today.attendance_time.nil? && @work_today.leaving_time.nil?
      @work = @work_today
      @work.attendance_time = Time.current
    elsif !@work_today.attendance_time.nil? && @work_today.leaving_time.nil?
      @work = @work_today
      @work.leaving_time = Time.current
    end
    
    if @work.save
      @youbi = %w[日 月 火 水 木 金 土][@work.day.wday]
      flash[:notice] = "#{@work.day.strftime("%-m/%-d")}(#{@youbi}) の勤怠時間を登録しました"
      redirect_to ("/attendance/attendance/#{@work.user.id}")
    else
      flash[:notice] = "勤怠時間の登録に失敗しました"
      redirect_to ("/attendance/attendance/#{@current_user.id}")
    end
  end

  def update
    if params[:work_id].nil?
      @work = Work.new(
        attendance_time: params[:attendance_time],
        leaving_time: params[:leaving_time],
        remarks: params[:remarks],
        day: params[:day],
        user_id: params[:user_id]
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
      redirect_to ("/attendance/attendance/#{@work.user.id}")
    else
      flash[:notice] = "勤怠情報の編集に失敗しました"
      redirect_to ("/attendance/edit/#{@current_user.id}")
    end
  end
  
  def select_time
    @work = Work.new
  end
  
  def select
    @work = Work.new(
      attendance_time_edit: params[:attendance_time_edit],
      leaving_time_edit: params[:leaving_time_edit],
      user_id: params[:user_id]
    )
    if @work.save
      flash[:notice] = "基本情報を更新しました"
      redirect_to ("/attendance/attendance/#{@work.user.id}")
    else
      flash[:notice] = "基本情報の更新に失敗しました"
      redirect_to ("/attendance/edit/#{@current_user.id}")
    end
  end
  
  def next_month
    @user = User.find_by(id: params[:id])
    @first = Date.parse(params[:first_day])
    @first_day = @first.next_month(1)
    redirect_to ("/attendance/attendance/#{@user.id}/#{@first_day}")
  end

  def last_month
    @user = User.find_by(id: params[:id])
    @first = Date.parse(params[:first_day])
    @first_day = @first.prev_month(1)
    redirect_to ("/attendance/attendance/#{@user.id}/#{@first_day}")
  end
  
  def set_user
    @user = User.find_by(id: params[:id])
    @youbi = %w[日 月 火 水 木 金 土]
  end
  
  def ensure_correct_user
    @user = User.find_by(id: params[:id])
    if current_user.admin?
    elsif @user.id != @current_user.id
      flash[:notice] = "他ユーザー編集の権限がありません"
      redirect_to ("/attendance/attendance/#{@current_user.id}")
    end
  end
  
end