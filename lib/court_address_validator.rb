# class CourtAddressValidator < ActiveModel::Validator
#   def validate(record)
#     puts record.addresses.to_yaml
#     if record.has_visiting_address? && !record.latitude.present?
#       record.errors[:latitude] <<  "Lat/lon missing."
#     end
#   end
# end