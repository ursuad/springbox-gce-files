#!/bin/bash
set -e

header() {
    echo "================================================================================"
    echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
    echo "================================================================================"

}


AUTH_SERVER_SELECTOR="name=auth-server-frontend"
RECOMMENDATIONS_SELECTOR="name=recommendations-frontend"
REVIEWS_SELECTOR="name=reviews-frontend"

header "Getting external addresses for"
echo "- auth server"
echo "- recommendations server"
echo "- reviews server"

AUTH_SERVER_HOST=$(kubectl get svc -l ${AUTH_SERVER_SELECTOR} -o json | jq -r  ".items[0].status.loadBalancer.ingress[0].ip")
AUTH_SERVER_PORT=$( kubectl get svc -l ${AUTH_SERVER_SELECTOR} -o json | jq -r  ".items[0].spec.ports[0].port")
RECOMMENDATIONS_SERVER_HOST=$(kubectl get svc -l ${RECOMMENDATIONS_SELECTOR} -o json | jq -r  ".items[0].status.loadBalancer.ingress[0].ip")
RECOMMENDATIONS_SERVER_PORT=$( kubectl get svc -l ${RECOMMENDATIONS_SELECTOR} -o json | jq -r  ".items[0].spec.ports[0].port")
REVIEWS_SERVER_HOST=$(kubectl get svc -l ${REVIEWS_SELECTOR} -o json | jq -r  ".items[0].status.loadBalancer.ingress[0].ip")
REVIEWS_SERVER_PORT=$(kubectl get svc -l ${REVIEWS_SELECTOR} -o json | jq -r  ".items[0].spec.ports[0].port")

header "Got following values:"
echo "- auth server: ${AUTH_SERVER_HOST} at port ${AUTH_SERVER_PORT}"
echo "- recommendations server: ${RECOMMENDATIONS_SERVER_HOST} at port ${RECOMMENDATIONS_SERVER_PORT}"
echo "- auth server: ${REVIEWS_SERVER_HOST} at port ${REVIEWS_SERVER_PORT}"

read -r -p "Continue? [y/N] " response
case $response in
    [yY][eE][sS]|[yY])
        echo "Ok, moving on..."
        ;;
    *)
        echo "You're no fun"
        exit 0;
        ;;
esac

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
