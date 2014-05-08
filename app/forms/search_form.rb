class SearchForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  validate :q, :area_of_law, presence: true

  def self.model_name
    ActiveModel::Name.new(self, nil, "CourtSearch")
  end

  def persisted?
    false
  end

  attr_accessor :q, :area_of_law

end