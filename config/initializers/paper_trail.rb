module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :ip, :location
  end
end