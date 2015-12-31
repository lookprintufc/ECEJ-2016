class Crew::AdminsController < ApplicationController
  layout 'admin_layout'
  before_action :authenticate_crew_admin!

  def dashboard
    @users = User.all
    @eligible_users = User.eligible
    @non_eligible_users = User.waiting_list
    @disqualified_users = User.disqualified
    @allocated_users = User.allocated
    @first_lot = Lot.first
    @second_lot = Lot.second
    @third_lot = Lot.third
  end

  def index
    @admins = Crew::Admin.all

    respond_to do |format|
      format.html
      format.json { render json: @admins }
    end
  end

  def users
    @users = User.all

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def new_admin
    @admin = Crew::Admin.new
  end

  def create_admin  
    @admin = Crew::Admin.new(admin_params)

    if @admin.save
      redirect_to root_path, notice: "Admin criado com sucesso."
    else
      redirect_to crew_new_admin_path, alert: "Falha ao cadastrar novo admin."
    end
  end

  private 
  def admin_params
    params[:crew_admin][:confirmed_at] = Time.now
    params[:crew_admin][:confirmation_sent_at] = Time.now
    params.require(:crew_admin).permit(:name, :email, :password, 
                                       :password_confirmation, :confirmed_at,
                                       :confirmation_sent_at)
  end
end
