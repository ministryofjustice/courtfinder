class Admin::AreasOfLawGroupsController < ApplicationController
  def index
    @areas_of_law_group = AreaOfLawGroup.all

    respond_to do |format|
      format.html
      format.json { render json: @areas_of_law_group }
    end
  end

  def edit
    @areas_of_law_group = AreaOfLawGroup.find(params[:id])
  end
end
