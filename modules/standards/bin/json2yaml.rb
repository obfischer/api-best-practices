require 'json'
require 'yaml'

YAML.dump(JSON.parse($stdin.read))
