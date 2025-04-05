#!/usr/bin/env bash

set -e -u -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ ! $(2>&- command -v npx) ]; then
  1>&2 echo npx could not be found
  exit 1
fi

npx antora ${SCRIPT_DIR}/antora-playbook.yml
