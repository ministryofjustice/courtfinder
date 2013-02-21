class Court < ActiveRecord::Base
  attr_accessible :court_number, :info, :name
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  # Text search
  def self.search(search, page, per_page)
    paginate :per_page => per_page,
             :page => page,
             :conditions => ['name like ?', "%#{search}%"],
             :order => 'name'
  end

end
