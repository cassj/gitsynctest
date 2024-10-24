#!/bin/bash

usage() { echo "Usage: $0 -s s3://bucketname"; exit 0; }

[ $# -eq 0 ] && usage

while getopts "hus:" arg; do
  case $arg in
    s) # Specify S3 bucket for nested templates
      BUCKET=${OPTARG}
      ;;
    h | *) # Display help.
      usage
      exit 0
      ;;
  esac
done

[[ -z $BUCKET ]] && usage

# create a dir for your nested templates if it doesn't already exist
mkdir -p nested

# set up the pre-push hook to sync the template bucket before every git push
cat << EOF > .git/hooks/pre-push
#!/bin/sh
aws s3 sync nested/ s3://${BUCKET}/
exit 0

EOF

chmod +x .git/hooks/pre-push

