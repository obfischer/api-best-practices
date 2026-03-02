#!/usr/bin/env bash

set -e -u -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source  ${SCRIPT_DIR}/functions.sh

tempfile=$(mktemp)

cat modules/standards/data/http-related-standards.yaml \
  | convert_yaml_to_json \
  | jq '[ .standards.[] ] | sort_by(.title) | {standards: . }' \
  | yq -p=json > ${tempfile}

diff ${tempfile} modules/standards/data/http-related-standards.yaml

cat ${tempfile} > modules/standards/data/http-related-standards.yaml

rm ${tempfile} || true
