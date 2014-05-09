class SearchForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validates :q, presence: true
  validates :area_of_law, presence: true, if: :postcode_search?

  def initialize(params = {})
    params.each {|k,v| self.instance_variable_set("@#{k}", v) }
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "CourtSearch")
  end

  def persisted?
    false
  end

  attr_accessor :q, :area_of_law

  def postcode_entered?
    court_search.postcode_search?
  end

  def court_search
    CourtSearch.new(@q, {area_of_law: @area_of_law})
  end

  def postcode_search?
    court_search.postcode_search? if court_search
  end

end
