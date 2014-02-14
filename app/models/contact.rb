class Contact < ActiveRecord::Base
  belongs_to :court
  belongs_to :contact_type
  attr_accessible :in_leaflet, :name, :sort, :telephone, :contact_type_id

  validates :telephone, presence:true

  #Allow numbers and spaces only
  validates :telephone, :format => { :with =>  /^(?=.*\d)(?:[\d ]+)$/, 
                                    :message => "is invalid. Please enter a phone number, only digits and spaces allowed."}

  has_paper_trail :ignore => [:created_at, :updated_at]

  default_scope :order => :sort
end
