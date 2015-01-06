require 'spec_helper'

describe AddressSequencer do

  describe '.sequence' do

    it 'should sequence visiting then postal then others in alphabetic order' do
      addresses = create_addresses( %w{ aardvark postal bobcat visiting zebra} )
      sequenced_addresses = AddressSequencer.new(addresses).sequence
      expect(extract_keys(sequenced_addresses)).to eq %w{ visiting postal aardvark bobcat zebra }
    end

    it 'should sequence visiting then postal then others in alphabetic order when in mixed case' do
      addresses = create_addresses( %w{ aardvark Postal Bobcat visiting zebra} )
      sequenced_addresses = AddressSequencer.new(addresses).sequence
      expect(extract_keys(sequenced_addresses)).to eq %w{ visiting Postal aardvark Bobcat zebra }
    end

    it 'should sequence correctly when there are no Postal or Visiting address' do
      addresses = create_addresses( %w{ aardvark Bobcat zebra} )
      sequenced_addresses = AddressSequencer.new(addresses).sequence
      expect(extract_keys(sequenced_addresses)).to eq %w{ aardvark Bobcat zebra }
    end

    it 'should sequence correctly when there is just a visiting  and postal address' do
      addresses = create_addresses( %w{ Visiting Postal } )
      sequenced_addresses = AddressSequencer.new(addresses).sequence
      expect(extract_keys(sequenced_addresses)).to eq %w{ Visiting Postal }
    end

    it 'should sequence correctly when there is just a visiting and other addresses' do
      addresses = create_addresses( %w{ Aardvark Bobcat Visiting Zebra})
      sequenced_addresses = AddressSequencer.new(addresses).sequence
      expect(extract_keys(sequenced_addresses)).to eq %w{ Visiting Aardvark Bobcat Zebra }
    end

    it 'should sequence nil address types as General' do
      addresses = create_addresses( %w{ Aardvark Bobcat nil Visiting Zebra})
      sequenced_addresses = AddressSequencer.new(addresses).sequence
      expect(extract_keys(sequenced_addresses)).to eq %w{ Visiting Aardvark Bobcat General Zebra }
    end
   
  end


end


def extract_keys(array)
  keys = []
  array.each do |address|
    if address.address_type.nil?
      keys << 'General'
    else
      keys << address.address_type.name
    end
  end
  keys
end


def create_addresses(keys)
  array = []
  keys.each do |key|
    if key == 'nil'
      array << FactoryGirl.build(:fake_address, address_type: nil)
    else
      array << FactoryGirl.build(:fake_address, address_type: FactoryGirl.build(:address_type, name: key))
    end
  end
  array
end
