# == Schema Information
#
# Table name: towns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  county_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  old_id     :integer
#

class Town < ActiveRecord::Base
  attr_accessible :name, :county_id

  belongs_to :county
  
  default_scope  { order('LOWER(towns.name)') } # ignore case when sorting

  scope :with_county_name, -> {
  	joins('left outer join counties on counties.id = towns.county_id').select('counties.name as county_name, counties.id as county_id')
  }

  scope :with_duplicate_count, -> {
  	select('(select count(*) from towns t2 where t2.name=towns.name and t2.id != towns.id) as duplicates')
  }

end
