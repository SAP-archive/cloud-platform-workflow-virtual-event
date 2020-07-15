#!/usr/bin/env bash

# Prepares the app archive and manifest for upload:
# - removes previous app archive
# - creates app archive from core files
# - copies the archive and manifest to the accessible Chrome OS
#   download folder, ready for upload via the Cockpit

# Then uses 'cf push' to deploy directly.

appname=$(yq r manifest.yml applications[0].name)
echo CF app '${appname}'

rm app.zip
zip app.zip .npmrc package.json xs-app.json
cp manifest.yml app.zip ${HOME}/Downloads/

cf d ${appname} -f
cf push

