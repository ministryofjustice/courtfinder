class Email < ActiveRecord::Base
  belongs_to :court
  attr_accessible :address, :description
end
