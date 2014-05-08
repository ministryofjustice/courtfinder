class Admin::AreaOfLawGroupsController < ApplicationController
  
  respond_to :html, :json

  def index
    @groups = AreaOfLawGroup.all
    respond_with @groups
  end

  def new
    @group = AreaOfLawGroup.new
  end

  def create
    @group = AreaOfLawGroup.new(params[:area_of_law_group])
    if @group.save
      flash[:notice] = 'Group was successfully created.' 
      respond_with @group, location: admin_area_of_law_groups_path
    else
      render 'new'
    end
  end

  def edit
    @group = AreaOfLawGroup.find(params[:id])
  end

  def update
    @group = AreaOfLawGroup.find(params[:id])
    if @group.update_attributes(params[:area_of_law_group])
      flash[:notice] = 'Group was successfully updated.' 
      respond_with @group, location: admin_area_of_law_groups_path
    else
      render 'edit'
    end
  end

  def destroy
    @group = AreaOfLawGroup.find(params[:id])
    @group.destroy

    respond_with @group, location: admin_area_of_law_groups_path
  end

end
