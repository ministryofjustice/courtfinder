# Court Finder

## Set-up

### Data

Export from mySQL database and replace the files into /db/data. When exporting use 'Export Method' custom, 'Format' CSV and make sure you check 'Put columns names in the first row'.

#### Before importing

Some tables contain HTML which needs some simple manipulation before it is imported.

For the "court" table also check 'Remove carriage return/line feed characters within columns'. Then replace all instances of `\"` with `""` before importing.

For the "court_access" table (for facilities), replace `\"\"` with `""` and then `\"` with `""` before importing.

For opening times ("court_opening") order by court id, then opening type before exporting:

    SELECT * FROM `court_opening` ORDER BY court_id, court_opening_type_id

### Import

To add all court and address data run:

    rake import:all

You can see a list of individual import tasks by running `rake -T`.

Then source all the court images from the existing website:

    rake source:court_images

### Generating Map Locations

After court data has been imported, some courts may be missing their map locations. The locations can be generated from their post codes of the visiting addresses and imported by running:

    RAILS_ENV=production rake import:map_location

Some post codes are not recognised by the default map location provider. For them, please use Google Maps Labs and enter their location manually in the file below before re-running the script.

    db/data/manual_map_locations.yml


<!-- Then you need to process the court types by running:

    rake process:court_types -->

### Uploads

Court photos are resized when uploaded. This requires an install of ImageMagick on your environment. You can install this using Homebrew:

    brew install imagemagick

### Admin Area

[Sign-in](http://localhost:3000/admin/users/sign_in)

To get access to the admin area you will then need to create the first user manually via the rake task:

    rake "admin:create[mat@cjsdigital.org, the_password, Mat Harden]"
