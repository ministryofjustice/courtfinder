module Admin
  class AreaOfLawGroupsController < Admin::ApplicationController
    before_action :authorised?
    before_action :group, only: [:edit, :update, :destroy]
    respond_to :html, :json

    def index
      @groups = AreaOfLawGroup.all
      respond_with @groups
    end

    def new
      @group = AreaOfLawGroup.new
      respond_with @group
    end

    def create
      @group = AreaOfLawGroup.new(params[:area_of_law_group])
      respond_to do |format|
        if @group.save
          format.html { redirect_to groups_path, notice: success_message('created') }
          format.json { render json: @group, status: :created }
        else
          render_error_response(format, template: :new, model: @group,
                                        message: 'Group could not be created.')
        end
      end
    end

    def edit
      respond_with @group
    end

    def update
      if @group.update_attributes(params[:area_of_law_group])
        flash[:notice] = success_message('updated')
        respond_with @group, location: groups_path
      else
        respond_to do |format|
          render_error_response(format, template: :edit, model: @group,
                                        message: 'Group could not be updated.')
        end
      end
    end

    def destroy
      @group.destroy
      respond_with @group, location: groups_path
    end

    private

    def group
      @group ||= AreaOfLawGroup.find(params[:id])
    end

    def success_message(event)
      "Group was successfully #{event}."
    end

    def groups_path
      admin_area_of_law_groups_path
    end
  end
end
