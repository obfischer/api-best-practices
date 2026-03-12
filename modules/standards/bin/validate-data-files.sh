#!/usr/bin/env bash

set -e -u -o pipefail

EXIT_CODE=0
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/functions.sh"

FIELDS_TO_VALIDATE="asciidocfile description title url status type"

for FIELD_TO_VALIDATE in ${FIELDS_TO_VALIDATE}; do
  if [[ "asciidocfile" == "${FIELD_TO_VALIDATE}" ]]; then
    echo "Not allowed name for Asciidoc file:"

    validation_result=$(
      cat modules/standards/data/http-related-standards.yaml \
        | convert_yaml_to_json \
        | jq \
          -r \
          --arg field "${FIELD_TO_VALIDATE}" \
          --arg regex '^[a-z0-9]+(?:[-.][a-z0-9]+)+\.adoc$' \
          '
            [ .standards.[] ]
            | sort_by(.title)
            | map(select( ((.[$field] // "") | tostring | test($regex)) | not ))
            | "- " + .[].title
          '
    )

    if [[ ! -z ${validation_result} ]]; then
        echo "${validation_result}"
        EXIT_CODE=1
    fi
    echo

  fi;

  echo "Missing value for required field '${FIELD_TO_VALIDATE}':"
  validation_result=$(cat modules/standards/data/http-related-standards.yaml \
    | convert_yaml_to_json \
    | jq -r '[ .standards.[] ] | sort_by(.title) | map(select(.'"${FIELD_TO_VALIDATE}"' == null)) | "- " + .[].title')

  if [[ ! -z ${validation_result} ]]; then
    echo "${validation_result}"
    EXIT_CODE=1
  fi
  echo
done

exit ${EXIT_CODE}
