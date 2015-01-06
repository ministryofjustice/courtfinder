require 'spec_helper'

describe AddressSequencer do

  describe '.sequence!' do

    it 'should sequence visisting then postal then others in alphabetic order' do
      addresses = create_addresses( [ 'aardvark', 'postal', 'bobcat', 'visiting', 'zebra'])

    end


  end


end



def create_addresses(keys)
  addresses = []
  keys.each do |key|

    address = { 
      'type' => key,
      # 'town' => Faker::Address.town,
      # 'county' => Faker::Address.county,
      'postcode' => Faker::Address.postcode,
      'lines' => []
    }

  end

end