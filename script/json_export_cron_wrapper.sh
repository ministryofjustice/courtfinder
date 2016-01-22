cd "$(dirname "$0")"
/usr/bin/python ./admin-db-to-json.py --db $DB_NAME --host $DB_HOST --user $DB_USERNAME --password $DB_PASSWORD --access $AWS_ACCESS_KEY --secret $AWS_SECRET_KEY --bucket $S3_BUCKET
