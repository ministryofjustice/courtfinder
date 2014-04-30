module PaperTrail
  class Version < ActiveRecord::Base
    attr_accessible :ip, :network
  end
end