module Admin
  class CourtsController < Admin::ApplicationController
    before_action :authorised?, only: [:audit, :audit_csv, :destroy]
    before_action :court, only: [:show, :edit, :update, :destroy]
    before_action :set_flash_message, only: :update

    def index
      @courts = Court.by_name

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @courts }
      end
    end

    def show
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @court }
      end
    end

    def new
      @court = Court.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @court }
      end
    end

    def edit
      @court_contacts = @court.contacts.order(:sort)
    end

    def create
      @court = Court.new(params[:court])

      respond_to do |format|
        if @court.save
          message = 'Court was successfully created.'
          format.html { redirect_to edit_admin_court_path(@court), notice: message }
          format.json { render json: @court, status: :created, location: @court }
        else
          render_error_response(format, template: :new, model: @court)
        end
      end
    end

    def update
      if @court.update_attributes(params[:court])
        respond_to do |format|
          format.html { redirect_to redirect_url, notice: 'Court was successfully updated.' }
          format.json { head :no_content }
        end
      else
        render_update_error_response
      end
    end

    def destroy
      @court.destroy

      respond_to do |format|
        format.html { redirect_to admin_courts_url }
        format.json { head :no_content }
      end
    end

    def areas_of_law
      @courts = Court.includes(:remits).by_name
      @areas_of_law = AreaOfLaw.all
      @court_lookup = @courts.map { |c| [c.id, c.remits.collect(&:area_of_law_id).to_set] }.to_h
    end

    def court_types
      @courts = Court.by_name.paginate(page: params[:page], per_page: 30)
      @court_types = CourtType.order(:name)
    end

    def family
      @courts = Court.by_area_of_law(AreaOfLaw.family_group).
                by_name.paginate(page: params[:page], per_page: 30)
      @area_of_law = area_of_law_by_id_or_name
    end

    def civil
      @courts = Court.by_area_of_law(AreaOfLaw.civil_group).
                by_name.paginate(page: params[:page], per_page: 30)
    end

    def audit
      @courts = Court.by_name
      render text: AuditCsvService.generate
    end

    private

    def court
      @court ||= Court.friendly.find(params[:id])
    end

    def redirect_url
      params[:redirect_url] || edit_admin_court_path(@court)
    end

    def render_html_update_response
      if params[:redirect_url]
        redirect_to params[:redirect_url], notice: @court.errors.messages.values.join("\n")
      else
        render :edit
      end
    end

    def render_update_error_response
      respond_to do |format|
        format.html { render_html_update_response }
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
    end

    def set_flash_message
      return if @court.invalid_local_authorities.blank?
      flash[:invalid_local_authorities] = @court.invalid_local_authorities
    end

    def area_of_law_by_id_or_name
      area_of_law = AreaOfLaw.where(id: params[:area_of_law_id]).first
      return area_of_law if area_of_law.present?
      AreaOfLaw.where(name: AreaOfLaw::Name::CHILDREN).first
    end
  end
end
