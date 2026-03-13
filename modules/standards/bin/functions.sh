# shellcheck shell=bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function convert_yaml_to_json() {
  # shellcheck disable=SC2016
  ruby -r yaml -r json -e 'puts YAML.load($stdin.read).to_json'
}

function convert_json_to_yaml() {
   ruby -- "${SCRIPT_DIR}/json2yaml.rb"
}

function generate_list_of_links() {
  (( $# == 1 )) || { echo "${FUNCNAME[0]}: expected 1 argument" >&2; return 1; }

  # shellcheck disable=SC2001
  suffix=$(echo "${1}" | sed 's/[[:space:]]/_/g')

   jq \
    --arg suffix "${suffix}" \
    -r \
   '
    .[]
    | .status
    |= ( {"draft": "{draft}", "obsolete": "{obsolete}"}[.] // "{active}" )
    | "* [[" + .asciidocfile + "_" + $suffix + "]] xref:" + .asciidocfile + "[" + .title + "]{nbsp}" + .status
   '
}

function sort_by_field() {
  (( $# == 1 )) || { echo "${FUNCNAME[0]}: expected 1 argument" >&2; return 1; }

  fieldname="$1"
  jq --arg fieldname "$fieldname" ".standards | sort_by(.[\$fieldname])"
}

function filter_by_field_and_value() {
  (( $# == 2 )) || { echo "${FUNCNAME[0]}: expected 2 arguments" >&2; return 1; }

  fieldname="$1"
  fieldvalue="$2"

  # Die Bedinung in der jq-Anweisung ist ein Hack für das Skript, welches
  # die Seite mit der Sortierung nach den Themen erstellt. Nur für dieses
  # Skript wird mit einem Array gearbeitet und nicht nur mit einem
  # einfachen Feldnamen
  # Oliver B. Fischer, 2026-03-11
  jq \
    --arg fieldname "${fieldname}" \
    --arg fieldvalue "${fieldvalue}" \
    '[ .standards[] | select( any( (if ($fieldname | endswith(".[]")) then .[$fieldname | rtrimstr(".[]")][] else .[$fieldname] end) == $fieldvalue; . ) ) ]'
}

function filter_by_field_and_valuestart() {
  (( $# == 2 )) || { echo "${FUNCNAME[0]}: expected 2 arguments" >&2; return 1; }

  fieldname="$1"
  fieldstart="$2"

  jq \
    --arg fieldname "${fieldname}" \
    --arg fieldstart "${fieldstart}" \
    '[ .standards[] | select( any( (if ($fieldname | endswith(".[]")) then .[$fieldname | rtrimstr(".[]")][] else .[$fieldname] end | ascii_upcase); startswith($fieldstart) ) ) ]'
}