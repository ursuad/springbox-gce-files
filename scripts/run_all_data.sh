#!/bin/bash
set -e

header() {
    echo "================================================================================"
    echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
    echo "================================================================================"

}


AUTH_SERVER_HOST="localhost"
AUTH_SERVER_PORT=$(kubectl get pod -l app=auth-server -o json |  jq -r  ".items[0].spec.containers[0].ports[0].containerPort")
RECOMMENDATIONS_SERVER_HOST="localhost"
RECOMMENDATIONS_SERVER_PORT=$(kubectl get pod -l app=springbox-recommendations -o json |  jq -r  ".items[0].spec.containers[0].ports[0].containerPort")
REVIEWS_SERVER_HOST="localhost"
REVIEWS_SERVER_PORT=$(kubectl get pod -l app=springbox-reviews -o json |  jq -r  ".items[0].spec.containers[0].ports[0].containerPort")

header "Got following values:"
echo "- auth server: ${AUTH_SERVER_HOST} at port ${AUTH_SERVER_PORT}"
echo "- recommendations server: ${RECOMMENDATIONS_SERVER_HOST} at port ${RECOMMENDATIONS_SERVER_PORT}"
echo "- auth server: ${REVIEWS_SERVER_HOST} at port ${REVIEWS_SERVER_PORT}"


header "Getting access token from server..."
TOKEN=$(curl -X POST -d "grant_type=password&username=mstine&password=secret" http://${AUTH_SERVER_HOST}:${AUTH_SERVER_PORT}/uaa/oauth/token -H "Authorization: Basic YWNtZTphY21lc2VjcmV0" | jq -r '.access_token')
echo "Got access_token: ${TOKEN}"

header "Loading reviews"
source reviews/loadReviews.sh ${AUTH_SERVER_HOST} ${AUTH_SERVER_PORT} ${REVIEWS_SERVER_HOST} ${REVIEWS_SERVER_PORT}


header "Loading People..."
source recommendations/loadPeople.sh ${TOKEN} ${RECOMMENDATIONS_SERVER_HOST} ${RECOMMENDATIONS_SERVER_PORT}
header "Loading Movies..."
source recommendations/loadMovies.sh ${TOKEN} ${RECOMMENDATIONS_SERVER_HOST} ${RECOMMENDATIONS_SERVER_PORT}
header "Loading Likes..."
source recommendations/loadLikes.sh ${TOKEN} ${RECOMMENDATIONS_SERVER_HOST} ${RECOMMENDATIONS_SERVER_PORT}
