#!/usr/bin/env bash

# Delete one or more destinations

destinations=$@

instance=$(uuidgen)
key=$(uuidgen)

echo Setup ...

# Create destination service instance and service key
cf create-service destination lite ${instance}
cf csk ${instance} ${key}

# Save the service key details and generate an access token
cf service-key ${instance} ${key} | sed 1,2d > ./key.json
token=$(gettoken)

for destination in ${destinations}; do
  echo -n "Destinations with name '${destination}' deleted: "
  curl \
    --silent \
    --request DELETE \
    --header "Authorization: Bearer ${token}" \
    "$(skv uri)/destination-configuration/v1/subaccountDestinations/${destination}" \
  | jq -r .Count
done

echo Teardown ...

# Remove service key details, service key and service instance
rm ./key.json
dsik ${instance}



