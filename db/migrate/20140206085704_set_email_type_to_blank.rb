class SetEmailTypeToBlank < ActiveRecord::Migration
  def up
    Email.reset_column_information

    # Contact types are sorted by name, blank will be first on each environment
    blank_id = ContactType.first.id

    emails = Email.all

    emails.each do |e|
      if e.contact_type_id.nil?
        e.contact_type_id = blank_id
        e.save
      end
    end
  end
end
