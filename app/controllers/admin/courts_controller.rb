class Admin::CourtsController < Admin::ApplicationController
  before_filter :authorised?, :only => [:audit, :audit_csv, :get_association_changeset]

  # GET /courts
  # GET /courts.json
  def index
    @courts = Court.by_name

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courts }
    end
  end

  # GET /courts/1
  # GET /courts/1.json
  def show
    @court = Court.friendly.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @court }
    end
  end

  # GET /courts/new
  # GET /courts/new.json
  def new
    @court = Court.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @court }
    end
  end

  # GET /courts/1/edit
  def edit
    @court = Court.friendly.find(params[:id])
    @court_contacts = @court.contacts.order(:sort)
  end

  # POST /courts
  # POST /courts.json
  def create
    @court = Court.new(params[:court])

    respond_to do |format|
      if @court.save
        purge_all_pages
        format.html { redirect_to edit_admin_court_path(@court), notice: 'Page was successfully created.' }
        format.json { render json: @court, status: :created, location: @court }
      else
        format.html { render action: "new" }
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courts/1
  # PUT /courts/1.json
  def update
    @court = Court.friendly.find(params[:id])
    if @court.update_attributes(params[:court])
      purge_all_pages
      flash[:invalid_local_authorities] = @court.invalid_local_authorities if @court.invalid_local_authorities

      respond_to do |format|
        format.html do
            redirect_to params[:redirect_url] || edit_admin_court_path(@court), notice: 'Court was successfully updated.'
        end
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html do
          if params[:redirect_url]
            redirect_to params[:redirect_url], notice: @court.errors.messages.values.join("\n")
          else
            render :edit
          end
        end
        format.json { render json: @court.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courts/1
  # DELETE /courts/1.json
  def destroy
    @court = Court.friendly.find(params[:id])
    @court.destroy
    purge_all_pages

    respond_to do |format|
      format.html { redirect_to admin_courts_url }
      format.json { head :no_content }
    end
  end

  def areas_of_law
    @courts = Court.includes(:remits).by_name
    @areas_of_law = AreaOfLaw.all
  end

  def court_types
    @courts = Court.by_name.paginate(page: params[:page], per_page: 30)
    @court_types = CourtType.order(:name)
  end

  def family
    @courts = Court.by_area_of_law([AreaOfLaw::Name::CHILDREN, AreaOfLaw::Name::DIVORCE, AreaOfLaw::Name::ADOPTION]).by_name.paginate(page: params[:page], per_page: 30)
    @area_of_law = AreaOfLaw.where(id: params[:area_of_law_id]).first || AreaOfLaw.where(name: AreaOfLaw::Name::CHILDREN).first
  end

  def civil
    @courts = Court.by_area_of_law([AreaOfLaw::Name::MONEY_CLAIMS, AreaOfLaw::Name::HOUSING_POSSESSION, AreaOfLaw::Name::BANKRUPTCY]).by_name.paginate(page: params[:page], per_page: 30)
  end

  def audit
    @courts = Court.by_name
    render text: audit_csv
  end

  def audit_csv
      versions = PaperTrail::Version.order("created_at DESC")
      CSV.generate do |csv|
        begin
          csv << ["datetime", "user_email","ip_address","court_name", "field_name", "action", "value_before", "value_after"]
          versions.each do |version|
            author_email = User.find(version.whodunnit).email if version.whodunnit
            value_before, value_after = [], []
            if version.item_type == "Court"
              court = Court.find version.item_id
              version.changeset.each do |key, value|
                csv << [version.created_at,
                        author_email,
                        version.ip,
                        court.name,
                        key,
                        version.event,
                        value[0],
                        value[1]
                        ]
              end
            else
              if version.event == "destroy"
                value_before = version.previous.try(:object)
                value_after = ""
                if court_id = get_court_id_from_previous_version(version)
                  if court = Court.find(court_id)
                    csv << [version.created_at,
                            author_email,
                            version.ip,
                            court.name,
                            version.item_type,
                            version.event,
                            value_before,
                            value_after
                            ]
                  end
                end
              else
                if item = version.item_type.constantize.find_by_id(version.item_id)
                  if court = item.court
                    version.changeset.each do |key, value|
                      value_before << "#{key}: #{value[0]}" unless version.event == "create"
                      value_after << "#{key}: #{value[1]}"
                    end
                    csv << [version.created_at,
                            author_email,
                            version.ip,
                            court.name,
                            version.item_type,
                            version.event,
                            value_before,
                            value_after
                            ]
                  end
                end
              end
            end
          end
        rescue Exception => e
          logger.info e.message
        end
      end
  end

  def get_court_id_from_previous_version(version)
    version.previous.try(:object).try(:split, "\n").try(:grep, /court_id/).try(:first).try(:gsub,"court_id: ","").try(:to_i)
  end
end
