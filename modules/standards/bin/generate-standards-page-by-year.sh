#!/usr/bin/env bash

set -e -u -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source  ${SCRIPT_DIR}/functions.sh

source_file=$1
output_file=$2

echo > ${output_file}
for year in $( cat ${source_file} | convert_yaml_to_json | jq .  |  jq -r ".standards.[].year" | sort -r | uniq ); do
  echo "=== ${year}" >> ${output_file}
  cat ${source_file} | convert_yaml_to_json | filter_by_field_and_value year ${year} | generate_list_of_links >> ${output_file}
  echo >> ${output_file}
done
