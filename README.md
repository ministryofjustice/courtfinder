# Court Finder

[![Build Status](https://api.shippable.com/projects/54325aba80088cee586d4ca6/badge?branchName=master)](https://app.shippable.com/projects/54325aba80088cee586d4ca6/builds/latest)
[![Code Climate](https://codeclimate.com/github/ministryofjustice/courtfinder.png)](https://codeclimate.com/github/ministryofjustice/courtfinder)
## Set-up

### ImageMagick

Court photos are resized when uploaded. This requires an install of ImageMagick on your environment. Install manually using from [http://www.imagemagick.org/script/index.php] or [http://cactuslab.com/imagemagick/].

Then run:

    which convert

Note the path to ImageMagick and run the following line (replacing with your path to ImageMagick) before running bundle install. The below example is based on a `which convert` output of `/opt/ImageMagick/bin/convert`:

    export PKG_CONFIG_PATH="/opt/ImageMagick/lib/pkgconfig:$PKG_CONFIG_PATH"

### Data

Consult the `deployment` repository for instructions on how to clone production data.

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

### Admin Area

[Sign-in](http://localhost:3000/admin/users/sign_in)

To get access to the admin area you will then need to create the first user manually via the rake task:

    rake "admin:create[sue@example.com, the_password, Sue Denim]"
