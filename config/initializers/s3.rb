@s3_creds = YAML.load(ERB.new(File.read("#{Rails.root}/config/s3.yml")).result)
