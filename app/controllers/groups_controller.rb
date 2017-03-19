class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]


  def index
    @groups = Group.all.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      redirect_to groups_path, notice: "新增成功！"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "编辑成功！"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: "已删除-"+@group.title
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:natice] = "加入本讨论组成功！"
    else
      flash[:warning] = "你已是本讨论组成员！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本讨论组!"
    else
      flash[:warning] = "你不是本讨论组成员！"
    end

    redirect_to group_path(@group)
  end



  private

  def group_params
    params.require(:group).permit(:title, :description)
  end

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "你没与权限这样做！"
    end
  end

end
