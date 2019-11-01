#!/bin/bash

echo "Registering runner"
/entrypoint register \
    --executor "shell" \
    --url $GITLAB_URL \
    --template-config /config/runner-config.toml \
    --registration-token $REGISTRATION_TOKEN \
    --run-untagged="false" \
    --tag-list "$TAGS" \
    --env "NO_PROXY=$NO_PROXY" \
    --env "HTTP_PROXY=$HTTP_PROXY" \
    --env "HTTPS_PROXY=$HTTPS_PROXY" \
    $ADDITIONAL_REGISTRATION_PARAMS

echo "Starting runner"

/entrypoint run --user=gitlab-runner --working-directory /home/gitlab-runner