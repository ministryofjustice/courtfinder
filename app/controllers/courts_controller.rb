class CourtsController < ApplicationController

  respond_to :html, :json, :csv

  before_filter :find_court, except: [:index]
  before_filter :set_vary_header, only: [:index, :show]

  def index
    @courts = Court.by_name
    if params[:compact]
      respond_to do |format|
        format.json do
          render 'index_compact' and return
        end
      end
    else
      respond_to do |format|
        format.html
        format.json do
          render content_type:'application/ld+json'
        end
        format.csv do
          render text: courts_csv
        end
      end
    end
  end

  def information
    if request.path != information_path(@court, format: params[:format])
      redirect_to information_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def defence
    if request.path != defence_path(@court, format: params[:format])
      redirect_to defence_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def prosecution
    if request.path != prosecution_path(@court, format: params[:format])
      redirect_to prosecution_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def juror
    if request.path != juror_path(@court, format: params[:format])
      redirect_to juror_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_with @court
    end
  end

  def show
    if request.path != court_path(@court, format: params[:format])
      redirect_to court_path(@court, format: params[:format]), status: :moved_permanently
    else
      respond_to do |format|
        format.html
        format.json do
          render content_type:'application/ld+json'
        end
      end
    end
  end

  private
  def find_court
    @court = Court.friendly.find(params[:id])
  end

  def courts_csv
    CSV.generate do |csv|
      csv << ["url","name","image","latitude","longitude","postcode","town","address","phone contacts","email contacts","opening times"]
      @courts.visible.each do |court|
        if address = (court.addresses.postal.first || court.addresses.visiting.first)
          court_postcode = address.postcode
          court_town = address.town.present? ? address.town.name : ''
          court_address = []
          court_address.push address.address_line_1 if address.address_line_1?
          court_address.push address.address_line_2 if address.address_line_2?
          court_address.push address.address_line_3 if address.address_line_3?
          court_address.push address.address_line_4 if address.address_line_4?
          court_address.push address.dx if address.dx?
        end
        court_telephone_contacts = []
        court.contacts.each do | contact |
          contact_line = [contact.telephone]
          contact_line.unshift "#{contact.contact_type.name}: " if contact.contact_type && contact.contact_type.name.present?
          court_telephone_contacts.push contact_line.join
        end
        court_contact_points = []
        court.emails.each do | email |
          email_line = [email.address]
          email_line.unshift "#{email.contact_type.name}: " if email.contact_type && email.contact_type.name.present?
          court_contact_points.push(email_line.join)
        end
        court_opening_times = []
        court.opening_times.each do |time|
          opening_name = time.opening_type.try(:name)
          court_opening_times.push("#{opening_name}#{": " if opening_name}#{time.name}")
        end
        csv << [court_path(court),
                court.name,
                court.image_file_url.present? ? court.image_file_url : nil,
                court.latitude,
                court.longitude,
                court_postcode,
                court_town,
                court_address ? court_address.join(', ') : nil,
                court_telephone_contacts != [] ? court_telephone_contacts.join(', ') : nil,
                court_contact_points != [] ? court_contact_points.join(', ') : nil,
                court_opening_times != [] ? court_opening_times.join(', ') : nil,
               ]
      end
    end
  end
end
