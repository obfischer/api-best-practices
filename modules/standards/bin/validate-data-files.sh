#!/usr/bin/env bash

set -e -u -o pipefail

EXIT_CODE=0
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source  ${SCRIPT_DIR}/functions.sh

FIELDS_TO_VALIDATE="title url status type"

for FIELD_TO_VALIDATE in ${FIELDS_TO_VALIDATE}; do
  echo "Missing value for required field '${FIELD_TO_VALIDATE}':"
  validation_result=$(cat modules/standards/data/http-related-standards.yaml \
    | convert_yaml_to_json \
    | jq -r '[ .standards.[] ] | sort_by(.title) | map(select(.'${FIELD_TO_VALIDATE}' == null)) | "- " + .[].title')

  if [[ ! -z ${validation_result} ]]; then
    echo ${validation_result}
    EXIT_CODE=1
  fi
  echo

done

exit ${EXIT_CODE}
