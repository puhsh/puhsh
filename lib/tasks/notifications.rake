namespace :notifications do
  desc 'Creates the respective Rapns app'
  task :create_rapn_app => :environment do
    app = Rapns::Apns::App.new
    app.name = Rails.environment.production? ? 'puhsh' : "puhsh_#{Rails.env}"
    app.certificate = File.read("#{Rails.root}/config/certs/puhsh_#{Rails.env}.pem")
    apn.environment = Rails.env
    app.connections = 1
    app.save!
  end
end
