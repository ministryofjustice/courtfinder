# Court Finder

[![Build Status](https://api.shippable.com/projects/54325aba80088cee586d4ca6/badge?branchName=master)](https://app.shippable.com/projects/54325aba80088cee586d4ca6/builds/latest)
[![Code Climate](https://codeclimate.com/github/ministryofjustice/courtfinder/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/courtfinder)
[![Test Coverage](https://codeclimate.com/github/ministryofjustice/courtfinder/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/courtfinder)
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


### Gov.uk API

#### Database

The following fields have been added to the courts table to enable the gov.uk api:

- uuid: a unique identifier for each court.  These are added automatically to all new records
- gov_uk_md5: an md5 hash of the court details serialized into a json hash that was last successfully uploaded to gov.uk
- gov_uk_updated_at: date and time the record was last pushed to gov.uk
- public_url: the public url which is returned from a gov.uk update

#### Implementation

All models which which impact the data that needs to be pushed to gov.uk include the Courts::GovUkPushable concern.  
This adds after_create, after_update and after_destroy hooks to the model to create a GovUkPushWorker sidekiq job with an 
action (:update, :create or :delete), and the id of the court record.  In the normal course of events, several jobs pertaining
to the same court record could be created, but the MD5 check (see below) prevents the same update being sent to gov.uk multiple
times.

The GovUkPushWorker sidekiq job instantiates GovUkPusher to do the following:
- find the court record
- serialize it and creates an MD5 hash of the serialized json
- if the MD5 hash does not match the MD5 hash on the court record (i.e. if the serialized data is 
  different from the last upload to gov.uk), then calls GovUKApiClient to push the data to gov.uk
  and update the court record with the new MD5 hash


#### Configuration

Configuration deatils (endpoint, token, active) are deatils in config/gov_uk_api.yml


