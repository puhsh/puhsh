namespace :notifications do
  desc 'Creates the iOS Rapns app'
  task :create_ios_rapn_app => :environment do
    app = Rapns::Apns::App.new
    app.name = Rails.env.production? ? 'puhsh_ios' : "puhsh_ios_#{Rails.env}"
    app.certificate = File.read("#{Rails.root}/config/certs/puhsh_#{Rails.env}.pem")
    app.environment = Rails.env
    app.connections = 1
    app.save!
  end

  desc 'Creates the GCM Rapns app'
  task :create_gcm_rapns_app => :environment do
    app = Rapns::Gcm::App.new
    app.name = Rails.env.production? ? 'puhsh_android' : "puhsh_android_#{Rails.env}"
    app.auth_key = YAML.load_file("#{Rails.root}/config/gcm.yml")[Rails.env]['key']
    app.connections = 1
    app.save!
  end
end
