# Court Finder

## Set-up

### Data

Export from mySQL database and replace the files into /db/data. When exporting use 'Export Method' custom, 'Format' CSV and make sure you check 'Put columns names in the first row'. 

For "court" table also check 'Remove carriage return/line feed characters within columns'. Then replace all instances of `\"` with `""` before importing.

To add all court and address data run:

    rake import:all

<!-- Then you need to process the court types by running:

    rake process:court_types -->

Don't forget you can see a list of individual import takes by running `rake -T`.

### Admin Area

[Sign-in](http://localhost:3000/admin/users/sign_in)

To get access to the admin area you will then need to create the first user manually via the Rails console (`rails console`)

    User.invite!(:email => "mat@cjsdigital.org", :name => "Mat Harden")

This will create the user and attempt to send an email invite. Then go to /admin/users/password/new and trigger the password reminder. Go to your server log and find the email output. Copy the invite link paste into your browser. You can enter a password of your own. Doing this will automatically sign you in.
