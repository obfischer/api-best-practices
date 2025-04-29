#!/usr/bin/env bash

set -e -u -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source  ${SCRIPT_DIR}/functions.sh

source_file=$1
output_file=$2

echo > ${output_file}

(cat ${source_file} | convert_yaml_to_json | jq .  |  jq -r ".standards.[].title[0:1] | ascii_upcase" | sort | uniq ) | while IFS= read -r line; do
    echo "=== ${line}" >> ${output_file}
    cat ${source_file} | convert_yaml_to_json | jq . | filter_by_field_and_valuestart title ${line} | generate_list_of_links >> ${output_file}
    echo >> ${output_file}
done

echo >> ${output_file}
