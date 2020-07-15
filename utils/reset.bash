#!/usr/bin/env bash

# Reset WFM environment in cf - use with care!
# Deletes the services set up by the WFM booster,
# and the apps and services deployed fromt the BPMServicesFLP.zip package.


function deleteApp () {
  # Deletes the app, including any routes
  local target=${1}
  cf delete -f -r ${target}
}

function deleteService () {
  # Deletes any service keys first, then the service instance target
  local target=${1}
  local servicekeys=$(cf sk ${target} | sed '1,3d' | awk '{print $1}')
  for servicekey in ${servicekeys}; do
    cf dsk -f ${target} ${servicekey}
  done
  cf ds -f ${target}
}

deleteApp BPMFLP
deleteApp BPMServicesFLP_appRouter

read -r -d '' instances <<EOF
BPMServicesFLP_html5_repo_runtime
default_connectivity
default_portal
default_processvisibility
default_workflow
uaa_bpmservices
EOF

for instance in ${instances}; do
  deleteService ${instance}
done


