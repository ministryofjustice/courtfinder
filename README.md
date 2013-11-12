# Court Finder

[![Build Status](https://travis-ci.org/ministryofjustice/courtfinder.png?branch=master)](https://travis-ci.org/ministryofjustice/courtfinder)

## Set-up

### ImageMagick

Court photos are resized when uploaded. This requires an install of ImageMagick on your environment. Install manually using from [http://www.imagemagick.org/script/index.php] or [http://cactuslab.com/imagemagick/].

Then run:

    which convert

Note the path to ImageMagick and run the following line (replacing with your path to ImageMagick) before running bundle install. The below example is based on a `which convert` output of `/opt/ImageMagick/bin/convert`:

    export PKG_CONFIG_PATH="/opt/ImageMagick/lib/pkgconfig:$PKG_CONFIG_PATH"

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

### Admin Area

[Sign-in](http://localhost:3000/admin/users/sign_in)

To get access to the admin area you will then need to create the first user manually via the rake task:

    rake "admin:create[sue@example.com, the_password, Sue Denim]"
