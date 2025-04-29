SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function convert_yaml_to_json() {
  ruby -r yaml -r json -e 'puts YAML.load($stdin.read).to_json'
}

function convert_json_to_yaml() {
   ruby -- ${SCRIPT_DIR}/json2yaml.rb
}

function generate_list_of_links() {
   #jq -r '.[] | "* " + .url + "[" + .title + "^]" + .status  + " " + (.status |= {A: 1, B: 9}[.]) '
   jq -r '.[] | .status |= {"draft": "{draft}", "obsolete": "{obsolete}"}[.]  | "* " + .url + "[" + .title + "^] " + .status'
}

function sort_by_field() {
  fieldname=$1
  jq ".standards | sort_by(.$fieldname)"
}

function filter_by_field_and_value() {
  fieldname=$1
  fieldvalue=$2

  jq "[ .standards.[] | select(.$fieldname == \"$fieldvalue\") ]"
}

function filter_by_field_and_valuestart() {
  fieldname=$1
  fieldstart=$2

  jq "[ .standards.[] | select( (.$fieldname | ascii_upcase ) | startswith(\"$fieldstart\")) ]"
}