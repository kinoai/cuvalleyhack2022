#!/usr/bin/env bash
cd deploy/
S3_URI=s3://$(terraform output --raw bucket_name)/
CLOUDFRONT_ID=$(terraform output --raw cloudfront_id)
PROFILE=${profile:=default}

cd ../app
rm -r build/
npm run build
if [ -d build ]
then
    aws s3 sync build/ $S3_URI --delete --profile $PROFILE
    aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_ID --paths "/*" --profile $PROFILE --
else
    printf "The build was unsuccessful."
fi
