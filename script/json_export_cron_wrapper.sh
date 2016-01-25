cd "$(dirname "$0")"
/usr/bin/python ./admin-db-to-json.py \
	--db $DB_NAME \
	--host $DB_HOST \
	--user $DB_USERNAME \
	--password $DB_PASSWORD \
	--bucket $S3_BUCKET
