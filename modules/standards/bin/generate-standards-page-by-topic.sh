#!/usr/bin/env bash

set -e -u -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source  ${SCRIPT_DIR}/functions.sh

source_file=$1
output_file=$2

echo > ${output_file}
(cat data/http-related-standards.yaml | convert_yaml_to_json | jq -r ".standards.[].topics.[]" | sort | uniq ) | while IFS= read -r topic; do
  echo "=== ${topic}" >> ${output_file}
  cat ${source_file} | convert_yaml_to_json | filter_by_field_and_value "topics.[]" "${topic}" | generate_list_of_links >> ${output_file}
  echo >> ${output_file}
done

echo >> ${output_file}
