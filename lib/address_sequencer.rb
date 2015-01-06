
# This class sorts addresses into a sequence of Visiting Address first, Postal address second, and any other addressses in alphabetic order
class AddressSequencer

  def initialize(addresses)
    @addresses = addresses
  end


  def sequence
    sorted_addresses = @addresses.sort { |a, b| key_value(a.address_type) <=> key_value(b.address_type) }
  end

  private

  def key_value(address_type)
    name = address_type.nil? ? "General" : address_type.name
    case name.upcase
    when 'VISITING'
      return '00'
    when 'POSTAL'
      return '01'
    else
      return '99' + name.upcase
    end
  end



end