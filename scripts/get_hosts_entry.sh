#!/usr/bin/env bash
set -e

header() {
    echo "================================================================================"
    echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
    echo "================================================================================"

}

AUTH_SERVER_SELECTOR="name=auth-server-frontend"
header "Getting external addresses for: "
echo   "      - auth server"
AUTH_SERVER_HOST=$(kubectl get svc -l ${AUTH_SERVER_SELECTOR} -o json | jq -r  ".items[0].status.loadBalancer.ingress[0].ip")
AUTH_SERVER_PORT=$( kubectl get svc -l ${AUTH_SERVER_SELECTOR} -o json | jq -r  ".items[0].spec.ports[0].port")
header "Got following values:"
echo "- auth server: ${AUTH_SERVER_HOST} at port ${AUTH_SERVER_PORT}"

header "Add the line below at the end of your /etc/hosts file"
echo "  ${AUTH_SERVER_HOST}  my-auth-server # Added for the Google Container Engine tutorial. Remove after"