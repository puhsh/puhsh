env = Rails.env.production? ? :production : :development

APN = Houston::Client.send(env.to_sym)
APN.certificate = File.read("#{Rails.root}/config/certs/puhsh_#{env}.pem")
