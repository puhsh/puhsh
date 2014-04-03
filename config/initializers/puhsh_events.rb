config =  YAML.load_file("#{Rails.root}/config/puhsh-events.yml")[Rails.env]
PUHSH_EVENTS = config.symbolize_keys
