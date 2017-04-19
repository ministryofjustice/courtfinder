class Admin::AreaOfLawGroupsController < Admin::ApplicationController
  before_action :authorised?

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
    respond_to do |format|
      if @group.save
        purge_all_pages
        format.html {
          flash[:notice] = 'Group was successfully created.' 
          respond_with @group, location: admin_area_of_law_groups_path
        }
        format.json{ render json: @group, status: :created }
      else
        format.html{
          flash[:error] = 'Group could not be created'
          render 'new'
        }
        format.json{
          render json: @group.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def edit
    @group = AreaOfLawGroup.find(params[:id])
  end

  def update
    @group = AreaOfLawGroup.find(params[:id])
    if @group.update_attributes(params[:area_of_law_group])
      purge_all_pages
      flash[:notice] = 'Group was successfully updated.' 
      respond_with @group, location: admin_area_of_law_groups_path
    else
      flash[:error] = 'Group could not be updated'
      render 'edit'
    end
  end

  def destroy
    @group = AreaOfLawGroup.find(params[:id])
    @group.destroy
    purge_all_pages

    respond_with @group, location: admin_area_of_law_groups_path
  end

end
