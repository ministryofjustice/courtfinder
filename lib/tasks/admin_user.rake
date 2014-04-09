namespace :admin do

  desc "Creates an admin user with given name, email and password."
  task :create, [:email, :password, :name] => :environment do |t, args|
    args.with_defaults(email: 'admin@test.com', password: '123123123', name: "Admin email")
    email, password, name = args[:email], args[:password],  args[:name]
    puts "Creating Admin user with name: #{name} and email: #{email} and with password: #{password}"

    User.create!(email: email,
                password: password,
                password_confirmation: password,
                name: name,
                admin: true)
    puts "Admin user created!"
  end
end
