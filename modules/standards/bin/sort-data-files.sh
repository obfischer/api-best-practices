#!/usr/bin/env bash

set -e -u -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source  ${SCRIPT_DIR}/functions.sh

tempfile=$(mktemp)

cat modules/standards/data/http-related-standards.yaml \
  | yq '.standards |= sort_by(.title) ' \
  > ${tempfile}

if diff ${tempfile} modules/standards/data/http-related-standards.yaml; then
  IS_UNSORTED=0
else
  IS_UNSORTED=1
fi

cat ${tempfile} > modules/standards/data/http-related-standards.yaml

rm ${tempfile} || true

# Soll mit <>0 aussteigen, auch wenn es sortiert wurde, damit
# die Pipeline fehlschlägt. Es liegt in der Verantwortung
# des Commiters die richtige Reihenfolge sicherzustellen.
# Oliver B. Fischer, 2026-03-07
exit ${IS_UNSORTED}
