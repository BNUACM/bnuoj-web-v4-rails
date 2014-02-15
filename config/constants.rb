require 'yaml'

def resolve_config_path(path)
    File.expand_path(File.join(File.dirname(__FILE__), "..", "config", path))
end

OJ_CONFIG = YAML.load(IO.read(resolve_config_path("oj_config.yml")))
JS_CONFIG = YAML.load(IO.read(resolve_config_path("js_config.yml")))
