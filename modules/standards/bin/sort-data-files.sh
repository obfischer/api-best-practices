#!/usr/bin/env bash

(( $# >= 0 )) || { echo "${BASH_SOURCE[0]}: expected no arguments" >&2; return 1; }

set -e -u -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/functions.sh"

wrap_description_lines() {
  local in_description=0
  while IFS= read -r line; do
    if [ $in_description -eq 0 ]; then
      if [[ "$line" =~ ^[[:space:]]+description:[[:space:]]*[">|"][[:space:]]*$ ]]; then
        in_description=1
      fi
      printf '%s\n' "$line"
    elif [ -z "$line" ]; then
      printf '\n'
    elif [[ "$line" != "      "* ]]; then
      in_description=0
      printf '%s\n' "$line"
    elif [ ${#line} -gt 80 ]; then
      printf '%s\n' "${line#      }" | fold -s -w 74 | sed 's/^/      /'
    else
      printf '%s\n' "$line"
    fi
  done
}

tempfile=$(mktemp)

cat modules/standards/data/http-related-standards.yaml \
  | yq '.standards |= sort_by(.title) ' \
  | wrap_description_lines \
  > "${tempfile}"

if diff "${tempfile}" modules/standards/data/http-related-standards.yaml; then
  IS_UNSORTED=0
else
  IS_UNSORTED=1
fi

cat "${tempfile}" > modules/standards/data/http-related-standards.yaml

rm "${tempfile}" || true

# Soll mit <>0 aussteigen, auch wenn es sortiert wurde, damit
# die Pipeline fehlschlägt. Es liegt in der Verantwortung
# des Commiters die richtige Reihenfolge sicherzustellen.
# Oliver B. Fischer, 2026-03-07
exit ${IS_UNSORTED}
