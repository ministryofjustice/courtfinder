namespace :maintenance do
  task :phone_numbers => [:environment] do
    Contact.transaction do
      Contact.find_each do |c|
        puts c.telephone
        if number = GlobalPhone.parse(c.telephone, :gb)
          c.telephone = number.normalized
          c.save!
        end
        puts c.telephone
      end
    end
  end
end

