#!/usr/bin/env bash

if [ ! -n "$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_KEY" ]; then
  error 'Please specify key property'
  exit 1
fi

if [ ! -n "$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_SECRET" ]; then
  error 'Please specify secret property'
  exit 1
fi

if [ ! -n "$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_FILE" ]; then
  error 'Please specify file property'
  exit 1
fi

if [ ! -n "$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_GIT_OWNER" ]; then
  error 'Please specify git_owner property'
  exit 1
fi

if [ ! -n "$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_GIT_REPOSITORY" ]; then
  error 'Please specify git_repository property'
  exit 1
fi

if [ ! -f "$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_FILE" ]; then
    error "Not found file $WERCKER_BITBUCKET_UPLOAD_ARTIFACT_FILE"
    exit 1
fi

pge=$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_GIT_OWNER/$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_GIT_REPOSITORY/downloads

secret_key=$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_KEY:$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_SECRET

response=$(curl -X POST -u "$secret_key" \
 https://bitbucket.org/site/oauth2/access_token \
  -d grant_type=client_credentials)

echo "$response"
regex="\"(access_token)\": \"([^\"]*)\""

if [[ $response =~ $regex ]]
then
    access_token="${BASH_REMATCH[2]}"
    echo "$access_token"
else
    error "$f doesn't match" >&2 # this could get noisy if there are a lot of non-matching files
    exit 1
fi

curl -v \
  --header "Authorization: Bearer $access_token" \
  --form "files=@$WERCKER_BITBUCKET_UPLOAD_ARTIFACT_FILE" \
  --output ./utbb \
  "https://api.bitbucket.org/2.0/repositories/$pge"

rs_error=$(grep error ./utbb)

if [ -f ./utbb ] && [ -n "$rs_error" ]; then
    cat ./utbb
    exit 1
fi

