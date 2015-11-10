#!/usr/bin/env bash

header() {
    echo "================================================================================"
    echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
    echo "================================================================================"

}

header "Getting port-forward commands..."
AUTH_SERVER_POD_NAME=$(kubectl get pod -l app=auth-server -o json | jq -r  ".items[0].metadata.name")
AUTH_SERVER_POD_PORT=$(kubectl get pod -l app=auth-server -o json |  jq -r  ".items[0].spec.containers[0].ports[0].containerPort")

REVIEWS_POD_NAME=$(kubectl get pod -l app=springbox-reviews -o json | jq -r  ".items[0].metadata.name")
REVIEWS_POD_PORT=$(kubectl get pod -l app=springbox-reviews -o json |  jq -r  ".items[0].spec.containers[0].ports[0].containerPort")

RECOMMENDATIONS_POD_NAME=$(kubectl get pod -l app=springbox-recommendations -o json | jq -r  ".items[0].metadata.name")
RECOMMENDATIONS_POD_PORT=$(kubectl get pod -l app=springbox-recommendations -o json |  jq -r  ".items[0].spec.containers[0].ports[0].containerPort")

header "Run the commands below to generate background jobs for port forwarding"
echo "nohup kubectl port-forward -p ${AUTH_SERVER_POD_NAME} ${AUTH_SERVER_POD_PORT} &"
echo "nohup kubectl port-forward -p ${REVIEWS_POD_NAME} ${REVIEWS_POD_PORT} &"
echo "nohup kubectl port-forward -p ${RECOMMENDATIONS_POD_NAME} ${RECOMMENDATIONS_POD_PORT} &"
