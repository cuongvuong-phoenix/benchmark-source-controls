#! /usr/bin/bash

source .env

wrk -H 'Connection: keep-alive' --connections 64 --threads "$(nproc)" --duration 15 --timeout 5 "http://$HOST:$PORT/get_git_program?root_path=$REPO_PATH&commit_id=$COMMIT_SHA"
printf -- '=%.0s' {1..80}; echo
wrk -H 'Connection: keep-alive' --connections 256 --threads "$(nproc)" --duration 15 --timeout 5 "http://$HOST:$PORT/get_git_program?root_path=$REPO_PATH&commit_id=$COMMIT_SHA"
printf -- '=%.0s' {1..80}; echo
wrk -H 'Connection: keep-alive' --connections 512 --threads "$(nproc)" --duration 15 --timeout 5 "http://$HOST:$PORT/get_git_program?root_path=$REPO_PATH&commit_id=$COMMIT_SHA"
