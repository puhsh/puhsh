namespace :users do
  desc 'Activates user app invites'
  task :activate_app_invite => :environment do
    Device.ios.find_each do |device|
      user.app_invite.activate!
    end
  end
end
